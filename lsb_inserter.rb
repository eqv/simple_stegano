require 'chunky_png'

filename =  ARGV[0] || 'kitty.png'
image = ChunkyPNG::Image.from_file(filename)
input = ChunkyPNG::Image.from_file('tux.png')

(0...image.width).each do |w|
  (0...image.height).each do |h|
    int = image[w,h]
    r,g,b = int >> 24 & 0xff, int >> 16 & 0xff, int >> 8 & 0xff
    lsb = if input[w,h] > 256 then 1 else 0 end
    image[w, h] = ChunkyPNG::Color.rgba(r,g, (b&0xfe)+lsb, 255)
  end
end
image.save("hidden_"+filename, :fast_rgb)



