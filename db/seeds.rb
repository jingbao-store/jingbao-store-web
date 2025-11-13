require 'open-uri'

# Clear existing data
puts "Clearing existing data..."
Application.destroy_all
Category.destroy_all
AppVersion.destroy_all
puts "  ✓ Data cleared"

# Create categories
puts "Creating categories..."
categories = Category.create!([
  {
    name: "游戏娱乐",
    icon: "🎮",
    description: "各类休闲和动作游戏，专为智能眼镜优化",
    display_order: 1
  },
  {
    name: "影音视频",
    icon: "🎬",
    description: "视频播放器、音乐播放器等多媒体应用",
    display_order: 2
  },
  {
    name: "手机应用",
    icon: "📱",
    description: "配合智能眼镜使用的手机端应用",
    display_order: 3
  },
  {
    name: "工具效率",
    icon: "🔧",
    description: "实用工具类应用，提升使用效率",
    display_order: 4
  }
])
puts "  ✓ Created #{categories.length} categories"

# Helper method to attach screenshots
def attach_screenshots(app, screenshot_urls)
  screenshot_urls.each_with_index do |url, index|
    begin
      app.screenshots.attach(io: URI.open(url), filename: "screenshot#{index + 1}.jpg")
    rescue => e
      puts "    ⚠ Failed to attach screenshot #{index + 1} for #{app.name}: #{e.message}"
    end
  end
  puts "    ✓ Attached #{screenshot_urls.length} screenshot(s) for #{app.name}"
end

# Sample app for 游戏娱乐
puts "Creating game applications..."
game_category = categories.find { |c| c.name == "游戏娱乐" }

app1 = Application.create!(
  name: "小蜜蜂游戏",
  package_name: "com.rokid.bee.game",
  version: "1.0.0",
  description: "经典的小蜜蜂射击游戏，完美适配智能眼镜，支持手势控制和语音操作。体验复古游戏的乐趣，享受全新的AR游戏体验。",
  icon: { io: URI.open("https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=200&h=200&fit=crop"), filename: 'icon.jpg' },
  download_url: "https://github.com/jingbao-store/releases/download/v1.0.0/bee-game.apk",
  file_size: "13 MB",
  file_size_bytes: 13631488,
  developer: "Rokid",
  rating: 4.5,
  downloads: 1250,
  last_updated: Date.today - 15.days,
  min_android_version: "8.0",
  permissions: ["网络访问", "存储权限"].to_json,
  features: ["手势控制", "语音操作", "多关卡挑战"].to_json,
  category: game_category
)
attach_screenshots(app1, [
  "https://raw.githubusercontent.com/jingbao-store/jingbao-store/main/apps/applications/productivity/runsight/screenshot.jpeg",
  "https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=800&h=1400&fit=crop"
])

app2 = Application.create!(
  name: "太空冒险",
  package_name: "com.jingbao.space.adventure",
  version: "2.1.0",
  description: "在浩瀚的宇宙中探险，驾驶飞船完成各种任务。支持3D视觉效果，为眼镜设备特别优化。",
  icon: { io: URI.open("https://images.unsplash.com/photo-1614728263952-84ea256f9679?w=200&h=200&fit=crop"), filename: 'icon.jpg' },
  download_url: "https://example.com/space-adventure.apk",
  file_size: "25 MB",
  file_size_bytes: 26214400,
  developer: "Space Games Studio",
  rating: 4.8,
  downloads: 3420,
  last_updated: Date.today - 7.days,
  min_android_version: "9.0",
  permissions: ["网络访问", "存储权限", "传感器访问"].to_json,
  features: ["3D图形", "关卡系统", "成就系统"].to_json,
  category: game_category
)
attach_screenshots(app2, [
  "https://images.unsplash.com/photo-1538370965046-79c0d6907d47?w=800&h=1400&fit=crop",
  "https://images.unsplash.com/photo-1608889825271-9e98d32df5ec?w=800&h=1400&fit=crop"
])

# Sample app for 影音视频
puts "Creating video applications..."
video_category = categories.find { |c| c.name == "影音视频" }

app3 = Application.create!(
  name: "AR视频播放器",
  package_name: "com.jingbao.ar.player",
  version: "2.5.1",
  description: "专为智能眼镜优化的视频播放器，支持多种格式，字幕显示，手势控制播放进度。享受私人影院般的观影体验。",
  icon: { io: URI.open("https://images.unsplash.com/photo-1574375927938-d5a98e8ffe85?w=200&h=200&fit=crop"), filename: 'icon.jpg' },
  download_url: "https://example.com/ar-player.apk",
  file_size: "18 MB",
  file_size_bytes: 18874368,
  developer: "AR Media Labs",
  rating: 4.6,
  downloads: 5680,
  last_updated: Date.today - 3.days,
  min_android_version: "8.0",
  permissions: ["存储权限", "网络访问"].to_json,
  features: ["多格式支持", "字幕显示", "手势控制", "播放列表"].to_json,
  category: video_category
)
attach_screenshots(app3, [
  "https://images.unsplash.com/photo-1522869635100-9f4c5e86aa37?w=800&h=1400&fit=crop",
  "https://images.unsplash.com/photo-1560169897-fc0cdbdfa4d5?w=800&h=1400&fit=crop"
])

# Sample apps for 手机应用 (Phone companion apps)
puts "Creating phone companion applications..."
phone_category = categories.find { |c| c.name == "手机应用" }

app4 = Application.create!(
  name: "蓝牙键盘助手",
  package_name: "io.appground.blek",
  version: "1.2.0",
  description: "将您的手机变成蓝牙键盘，配合智能眼镜使用，提供便捷的文字输入体验。支持多种布局和快捷键设置。",
  icon: { io: URI.open("https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=200&h=200&fit=crop"), filename: 'icon.jpg' },
  download_url: "https://play.google.com/store/apps/details?id=io.appground.blek",
  file_size: "8 MB",
  file_size_bytes: 8388608,
  developer: "AppGround",
  rating: 4.4,
  downloads: 12500,
  last_updated: Date.today - 20.days,
  min_android_version: "7.0",
  permissions: ["蓝牙", "网络访问"].to_json,
  features: ["多种键盘布局", "自定义快捷键", "手势支持"].to_json,
  category: phone_category
)
attach_screenshots(app4, [
  "https://images.unsplash.com/photo-1629654291663-b91ad427698f?w=800&h=1400&fit=crop",
  "https://images.unsplash.com/photo-1595675024853-0f3ec9098ac7?w=800&h=1400&fit=crop"
])

app5 = Application.create!(
  name: "虚拟鼠标控制器",
  package_name: "com.jingbao.virtual.mouse",
  version: "3.0.2",
  description: "将手机变成无线鼠标和触摸板，配合眼镜实现精准的交互控制。支持手势操作和自定义按键。",
  icon: { io: URI.open("https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=200&h=200&fit=crop"), filename: 'icon.jpg' },
  download_url: "https://example.com/virtual-mouse.apk",
  file_size: "6 MB",
  file_size_bytes: 6291456,
  developer: "JingBao Team",
  rating: 4.7,
  downloads: 8930,
  last_updated: Date.today - 10.days,
  min_android_version: "8.0",
  permissions: ["蓝牙", "网络访问"].to_json,
  features: ["触摸板模式", "手势操作", "按键自定义", "多设备支持"].to_json,
  category: phone_category
)
attach_screenshots(app5, [
  "https://images.unsplash.com/photo-1555617778-02745084786f?w=800&h=1400&fit=crop",
  "https://images.unsplash.com/photo-1563206767-5b18f218e8de?w=800&h=1400&fit=crop"
])

app6 = Application.create!(
  name: "游戏手柄映射",
  package_name: "com.jingbao.gamepad.mapper",
  version: "1.5.0",
  description: "将手机变成游戏手柄，通过蓝牙连接眼镜，为游戏提供更好的操作体验。支持按键映射和震动反馈。",
  icon: { io: URI.open("https://images.unsplash.com/photo-1592840496694-26d035b52b48?w=200&h=200&fit=crop"), filename: 'icon.jpg' },
  download_url: "https://example.com/gamepad-mapper.apk",
  file_size: "10 MB",
  file_size_bytes: 10485760,
  developer: "Gaming Tools",
  rating: 4.3,
  downloads: 6740,
  last_updated: Date.today - 12.days,
  min_android_version: "8.0",
  permissions: ["蓝牙", "震动", "网络访问"].to_json,
  features: ["按键映射", "震动反馈", "多种预设", "低延迟"].to_json,
  category: phone_category
)
attach_screenshots(app6, [
  "https://images.unsplash.com/photo-1606144042614-b2417e99c4e3?w=800&h=1400&fit=crop",
  "https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=800&h=1400&fit=crop"
])

# Sample app for 工具效率
puts "Creating tool applications..."
tools_category = categories.find { |c| c.name == "工具效率" }

app7 = Application.create!(
  name: "AR录像工具",
  package_name: "com.jingbao.ar.recorder",
  version: "1.3.0",
  description: "专业的AR录像应用，记录您在智能眼镜中看到的一切。支持高清录制和实时预览。",
  icon: { io: URI.open("https://images.unsplash.com/photo-1492619375914-88005aa9e8fb?w=200&h=200&fit=crop"), filename: 'icon.jpg' },
  download_url: "https://example.com/ar-recorder.apk",
  file_size: "15 MB",
  file_size_bytes: 15728640,
  developer: "JingBao Tools",
  rating: 4.5,
  downloads: 4210,
  last_updated: Date.today - 5.days,
  min_android_version: "9.0",
  permissions: ["相机", "麦克风", "存储权限"].to_json,
  features: ["高清录制", "实时预览", "滤镜效果"].to_json,
  category: tools_category
)
attach_screenshots(app7, [
  "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=800&h=1400&fit=crop",
  "https://images.unsplash.com/photo-1485846234645-a62644f84728?w=800&h=1400&fit=crop"
])

# Create Jingbao APP version
puts "Creating Jingbao APP version..."
AppVersion.create!(
  app_id: "com.jingbao.store",
  version_name: "1.3.0",
  version_code: 5,
  update_time: Date.parse("2025-11-05"),
  download_url: "https://gitee.com/jingbao-store/jingbao-store/releases/download/v1.3.0/jingbao-store-v1.3.0.apk",
  file_size: "7.5M",
  file_size_bytes: 7879270,
  min_android_version: "7.0",
  release_notes: ["新增自动更新功能", "优化应用启动速度", "改进界面交互体验", "修复已知问题"].to_json,
  changelog: "v1.2.0\n- 新增自动更新功能\n- 优化应用启动速度\n- 改进界面交互体验\n- 修复已知问题",
  force_update: false
)
puts "  ✓ Created app version: v#{AppVersion.current.version_name}"

puts "✅ Seeding completed!"
puts "  - Created #{Category.count} categories"
puts "  - Created #{Application.count} applications"
puts "  - Created #{AppVersion.count} app version(s)"
puts ""
puts "Categories:"
Category.ordered.each do |cat|
  puts "  #{cat.icon} #{cat.name} (#{cat.applications.count} apps)"
end
