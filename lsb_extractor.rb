require 'chunky_png'

def ith_bit(val,i)
  if (val>>i)&1 > 0 then 255 else 0 end
end
(0..7).each do |bit|
  image = ChunkyPNG::Image.from_file('kitty_better_hidden.png')
  w,h = image.width,image.height
  puts [w,h].inspect
  (0...image.width).each do |w|
    (0...image.height).each do |h|
      int = image[w,h]
      r,g,b = int>>24 & 0xff, int >> 16 & 0xff, int >> 8 & 0xff
      image[w, h] = ChunkyPNG::Color.rgba(ith_bit(b,bit), ith_bit(b,bit), ith_bit(b,bit) , 255)
    end
  end
  image.save("kitty_#{bit}_extracted.png", :fast_rgb) # for RGB only images.
end
