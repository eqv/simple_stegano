require 'chunky_png'

  image = ChunkyPNG::Image.from_file('kitty.png')
  w,h = image.width,image.height
  puts [w,h].inspect
  (0...image.width).each do |w|
    (0...image.height).each do |h|
      int = image[w,h]
      r,g,b = int>>24 & 0xff, int >> 16 & 0xff, int >> 8 & 0xff
      image[w, h] = ChunkyPNG::Color.rgba(0,g,0,255)
    end
  end
  image.save("kitty_only_green_extracted.png", :fast_rgb) # for RGB only images.
