require 'chunky_png'

histogram = {}
(0..255).each{|i| histogram[i]=0}

image = ChunkyPNG::Image.from_file(ARGV[0] || 'kitty_hidden.png')
(0...image.width).each do |w|
  (0...image.height).each do |h|
    int = image[w,h]
    r,g,b = int>>24 & 0xff, int >> 16 & 0xff, int >> 8 & 0xff
    histogram[b]+=1
  end
end

histogram.each_pair do |color,count|
  puts "#{color}\t#{count}"
end
