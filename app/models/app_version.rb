class AppVersion < ApplicationRecord
  has_one_attached :apk_file

  validates :app_id, presence: true
  validates :version_name, presence: true
  validates :version_code, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :file_size, presence: true
  validates :file_size_bytes, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :must_have_download_source

  scope :latest, -> { order(version_code: :desc).first }
  scope :by_app_id, ->(app_id) { where(app_id: app_id) }

  def release_notes_array
    release_notes.present? ? JSON.parse(release_notes) : []
  rescue JSON::ParserError
    []
  end

  def self.current
    order(version_code: :desc).first
  end

  # 返回最终的下载 URL：优先使用上传的 APK 文件，否则使用 download_url 字段
  def final_download_url
    if apk_file.attached?
      begin
        url_options = Rails.application.routes.default_url_options
        Rails.application.routes.url_helpers.rails_blob_url(apk_file, **url_options)
      rescue => e
        Rails.logger.error("Error generating APK URL: #{e.message}")
        path = Rails.application.routes.url_helpers.rails_blob_path(apk_file, only_path: true)
        build_full_url(path)
      end
    else
      download_url
    end
  end

  # 自动计算并更新文件大小（当 APK 文件上传时）
  def update_file_size_from_apk
    return unless apk_file.attached?
    
    self.file_size_bytes = apk_file.byte_size
    self.file_size = format_file_size(file_size_bytes)
  end

  private

  # 验证：必须有下载来源（APK 文件或下载 URL）
  def must_have_download_source
    if !apk_file.attached? && download_url.blank?
      errors.add(:base, "必须提供 APK 文件或下载 URL 其中之一")
    end
  end

  # 格式化文件大小
  def format_file_size(bytes)
    return "0 B" if bytes.nil? || bytes == 0
    
    units = ['B', 'KB', 'MB', 'GB', 'TB']
    exponent = (Math.log(bytes) / Math.log(1024)).floor
    exponent = [exponent, units.length - 1].min
    
    size = bytes.to_f / (1024 ** exponent)
    
    if size >= 100
      "#{size.round(0).to_i} #{units[exponent]}"
    elsif size >= 10
      "#{size.round(1)} #{units[exponent]}"
    else
      "#{size.round(2)} #{units[exponent]}"
    end
  end

  # 构建完整的 URL（用于 APK 文件）
  def build_full_url(path)
    return path if path.blank? || path.start_with?('http')
    
    url_options = Rails.application.routes.default_url_options
    protocol = url_options[:protocol] || 'https'
    host = url_options[:host] || 'localhost'
    port = url_options[:port]
    
    base_url = "#{protocol}://#{host}"
    
    if port && !((protocol == 'https' && port == 443) || (protocol == 'http' && port == 80))
      base_url += ":#{port}"
    end
    
    "#{base_url}#{path}"
  end
end
