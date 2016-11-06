class BitmapEditor

  def run
    @running = true
    puts 'type ? for help'
    while @running
      print '> '
      input = gets.chomp
      args = input.split(" ")
      case args.first
        when '?'
          show_help
        when 'X'
          exit_console
        when 'S'
          show_image
        when 'C'
          clear_table
        when 'S'
          show_image
        when 'C'
          clear_table
        when 'I'
          create_image(args)
        when 'L'
          colour_pixel(args)
        when 'V'
          vertical_segment(args)
        when 'H'
          horizontal_segment(args)
        else
          puts 'unrecognised command :('
          return false
      end
    end
  end

  private

    def vertical_segment(args)
      if valid_table
        x = args[1].to_i - 1
        y1 = args[2].to_i - 1
        y2 = args[3].to_i - 1
        colour = args[4]  

        if valid_x(x) && valid_y(y1) && valid_y(y2) && y2 > y1
          rows = @rows[y1..y2]
          rows.each do |row|
            row[x] = colour
          end
        else
          puts "invalid params :("
          return false
        end
      else
        puts "no table defined :("
        return false
      end
    end

    def horizontal_segment(args)
      if valid_table
        x1 = args[1].to_i - 1
        x2 = args[2].to_i - 1
        y = args[3].to_i - 1
        colour = args[4]  

        if valid_x(x1) && valid_x(x2) && valid_y(y) && x2 > x1
          row = @rows[y]
          row[x1..x2] = colour * row[x1..x2].length
        else
          puts "invalid params :("
        end
      else
        puts "no table defined :("
      end
    end

    def colour_pixel(args)
      x = args[1].to_i - 1
      y = args[2].to_i - 1
      colour = args[3]

      if valid_x(x) && valid_y(y)
        row = @rows[y]
        row[x] = colour
      else
        puts "invalid params :("
        false
      end
    end

    def create_image(args)
      m = args[1].to_i
      n = args[2].to_i
      
      unless valid_image_size(m,n)
        puts 'invalid params :('
        return
      end

      @rows = []
      n.times do
        row = white_row(m)
        @rows.push(row)
      end
    end

    def white_row(length)
      "O" * length
    end

    def show_image
      puts @rows.join("\n") if valid_table
    end

    def valid_table
      @rows ? true : false
    end

    def valid_x(x)
      x += 1
      return false if x < 1 || x > @rows.first.length 
      true
    end

    def valid_y(y)
      y += 1
      return false if y < 1 || y > @rows.count
      true
    end

    def valid_image_size(m,n)
      [m,n].each do |arg|
        if arg < 1 || arg > 250
          return false
        end
      end
      true
    end

    def clear_table
      @rows.each do |row|
        row.gsub!(row,white_row(row.length))
      end
    end

    def exit_console
      puts 'goodbye!'
      @running = false
    end

    def show_help
      puts "? - Help
I M N - Create a new M x N image with all pixels coloured white (O).
C - Clears the table, setting all pixels to white (O).
L X Y C - Colours the pixel (X,Y) with colour C.
V X Y1 Y2 C - Draw a vertical segment of colour C in column X between rows Y1 and Y2 (inclusive).
H X1 X2 Y C - Draw a horizontal segment of colour C in row Y between columns X1 and X2 (inclusive).
S - Show the contents of the current image
X - Terminate the session"
    end
end
