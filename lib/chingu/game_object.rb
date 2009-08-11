module Chingu
  #
  # A basic class, all your ingame objects should be built on this. Encapsulates
  # Gosus draw_rot and it's parameters. 
  #
  # All objects that inherits from this class will automaticly be updated and drawn.
  #
  class GameObject
    attr_accessor :image, :x, :y, :angle, :center_x, :center_y, :factor_x, :factor_y, :color, :mode
    attr_accessor :update, :draw, :input
    attr_reader :options
    
    #
    # Class-level default values. 
    # This allows you to set default-values that affect all created GameObjects after that.
    # You might want to draw gameobjects from the top-left @ x/y instead of putting it's center there:
    # 
    # in Gosu::Window#initialize: GameObject.center_x = GameObject.center_y = 0
    #
    @@x = nil
    @@y = nil
    @@zorder = 100
    @@center_x = 0.5
    @@center_y = 0.5
    @@factor_x = 1.0
    @@factor_y = 1.0

    def self.x; @@x; end
    def self.x=(value); @@x = value; end

    def self.y; @@y; end
    def self.y=(value); @@y = value; end

    def self.zorder; @@zorder; end
    def self.zorder=(value); @@zorder = value; end

    def self.center_x; @@center_x; end
    def self.center_x=(value); @@center_x = value; end

    def self.center_y; @@center_y; end
    def self.center_y=(value); @@center_y = value; end

    def self.factor_x; @@factor_x; end
    def self.factor_x=(value); @@factor_x = value; end

    def self.factor_y; @@factor_y; end
    def self.factor_y=(value); @@factor_y = value; end

    #
    # Create a new GameObject. Arguments are given in hash-format:
    # 
    # :x        screen x-coordinate (default 0, to the left)
    # :y        screen y-coordinate (default 0, top of screen)
    # :angle    angle of object, used in draw_rot, (default 0, no rotation)
    # :zorder   a gameclass "foo" with higher zorder then gameclass "bar" is drawn on top of "foo".
    # :center_x relative horizontal position of the rotation center on the image. 
    #           0 is the left border, 1 is the right border, 0.5 is the center (default 0.5)
    # :center_y see center_x. (default 0.5)
    # :factor_x horizontal zoom-factor, use >1.0 to zoom in. (default 1.0, no zoom).
    # :factor_y vertical zoom-factor, use >1.0 to zoom in. (default 1.0, no zoom).
    #
    # :update [true|false] Automaticly call #update on object each gameloop. Default +true+.
    # :draw   [true|false] Automaticly call #update on object each gameloop. Default +true+.
    #
    def initialize(options = {})
      @options = options
      
      # draw_rot arguments
      @image = options[:image]          if options[:image].is_a? Gosu::Image
      @image = Image[options[:image]]   if options[:image].is_a? String
      
      @x = options[:x] || @@x || 0
      @y = options[:y] || @@y || 0
      @angle = options[:angle] || 0
      @zorder = options[:zorder] || @@zorder
      @center_x = options[:center_x] || options[:center] || @@center_x
      @center_y = options[:center_y] || options[:center] || @@center_y
      @factor_x = options[:factor_x] || options[:factor] || @@factor_x
      @factor_y = options[:factor_y] || options[:factor] || @@factor_y
      @color = options[:color] || 0xFFFFFFFF
      @mode = options[:mode] || :default # :additive is also available.
      
      # gameloop/framework logic
      @update = options[:update] || true
      @draw = options[:draw] || true
      @input = options[:input] || nil
      
      #
      # A GameObject can either belong to a GameState or our mainwindow ($window)
      # .. or live in limbo with manual updates
      #
      @parent = $window.game_state_manager.inside_state || $window
      @parent.add_game_object(self)  if @parent
    end
    
    #
    # Returns true if game object is inside the game window, false if outside
    #
    def inside_window?(x = @x, y = @y)
      x >= 0 && x <= $window.width && y >= 0 && y <= $window.height
    end
    
    def update(time = 1)
      # Objects gamelogic here, 'time' is the time passed between 2 iterations of the main game loop
		end
    
    #
    # The core of the gameclass, the draw_rot encapsulation. Draws the sprite on screen.
    # Calling #to_i on @x and @y enables thoose to be Float's, for subpixel slow movement in #update
    #
    def draw
      @image.draw_rot(@x.to_i, @y.to_i, @zorder, @angle, @center_x, @center_y, @factor_x, @factor_y, @color, @mode)
    end
  end
end