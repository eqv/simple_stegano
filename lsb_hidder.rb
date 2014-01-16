require 'chunky_png'

  def neighbors(x,y)
    res = []
    [-1,0,1].each do |ox|
      [-1,0,1].each do |oy|
        res << [x+ox,y+ox] unless ox == 0 && oy == 0
      end
    end
    return res
  end

  def is_valid_stego_pixel(image,allready_used,x,y)
    bits = []
    ng = neighbors(x,y)
    ng.each do |(nx,ny)|
      return false if nx < 0 || nx >= image.width
      return false if ny < 0 || ny >= image.height
      return false if allready_used.include?([nx,ny])
      bits << ((image[nx,ny]>>8)&1)
    end
    return true if bits.count(0) >= 2 and bits.count(1) >= 2
    return false
  end

  input = "Some Secret Message"*50
  srand(12345)# NOT A secret PRNG
  input = input.each_byte.map{|x| x.to_s(2).rjust(8,"0")}.join.split(//).map(&:to_i)
  puts input.inspect
  image = ChunkyPNG::Image.from_file('kitty.png')
  w,h = image.width,image.height
  puts [w,h].inspect
  allready_used = Set.new

  input.each.with_index do |bit,i|
      ok = false
      1000.times do
        x,y = rand(w-1), rand(h-1)
        next if !is_valid_stego_pixel(image,allready_used,x,y)
        allready_used << [x,y]
        int = image[x,y]
        r,g,b = int>>24 & 0xff, int >> 16 & 0xff, int >> 8 & 0xff
        image[x, y] = ChunkyPNG::Color.rgba(r, g, (b&0xfe)+bit, 255)
        ok = true
        break
      end
      if !ok
        raise "image is full, payload too big"
      end
  end
  image.save("kitty_better_hidden.png", :fast_rgb) # for RGB only images.
