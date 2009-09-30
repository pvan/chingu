#--
#
# Chingu -- Game framework built on top of the opengl accelerated gamelib Gosu
# Copyright (C) 2009 ippa / ippa@rubylicio.us
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
#
#++


module Chingu
  #
  # GameObject is our BasisGameObject (class with framespecific stuff)
  #
  # On top of that, it encapsulates GOSUs Image#draw_rot and all its parameters.
  #
  class GameObject < Chingu::BasicGameObject
    attr_accessor :image, :x, :y, :angle, :center_x, :center_y, :factor_x, :factor_y, :color, :mode, :zorder
    attr_reader :paused, :visible
    has_trait :input, :rotation_center
        
    def initialize(options = {})
      super

      # All encapsulated draw_rot arguments can be set with hash-options at creation time
      if options[:image].is_a?(Gosu::Image)
        @image = options[:image]
      elsif options[:image].is_a? String
        @image = Image[options[:image]]
      end
      
      @x = options[:x] || 0
      @y = options[:y] || 0
      @angle = options[:angle] || 0
      
      @center_x = options[:center_x] || options[:center] || 0.5
      @center_y = options[:center_y] || options[:center] || 0.5
      @factor_x = options[:factor_x] || options[:factor] || 1.0
      @factor_y = options[:factor_y] || options[:factor] || 1.0

      # faster?
      #self.center = options[:center] || 0.5
      #self.factor = options[:factor] || 1.0
      #@center_x = options[:center_x] || 0.5
      #@center_y = options[:center_y] || 0.5
      #@factor_x = options[:factor_x] || 1.0
      #@factor_y = options[:factor_y] || 1.0

      if options[:color].is_a?(Gosu::Color)
        @color = options[:color]
      elsif options[:color].is_a? Bignum
        @color = Gosu::Color.new(options[:color])
      else
        @color = Gosu::Color.new(0xFFFFFFFF)
      end
      
      @mode = options[:mode] || :default # :additive is also available.
      @zorder = options[:zorder] || 100
                        
      # gameloop/framework logic (TODO: use or get rid of)
      @paused = options[:paused] || false
      @visible = options[:visible] || true
      
      setup_trait(options)  if respond_to?(:setup_trait)
    end
    
    #
    # Disable auto-updating of traits 
    #
    def paus!
      @paused = true
    end
    #
    # Enable auto-update of traits
    #
    def unpause!
      @paused = false
    end
    #
    # Disable auto-drawing of object
    #
    def hide!
      @visible = false
    end
    #
    # Enable auto-drawing of object
    #
    def show!
      @visible = true
    end
    
    # Quick way of setting both factor_x and factor_y
    def factor=(factor)
      @factor_x = @factor_y = factor
    end
          
    # Quick way of setting both center_x and center_y
    def center=(center)
      @center_x = @center_y = center
    end

    # Returns true if object is inside the game window, false if outside
    def inside_window?(x = @x, y = @y)
      x >= 0 && x <= $window.width && y >= 0 && y <= $window.height
    end

    # Returns true object is outside the game window 
    def outside_window?(x = @x, y = @y)
      not inside_window?(x,y)
    end
    
    # Calculates the distance from self to a given objevt
    def distance_to(object)
      distance(self.x, self.y, object.x, object.y)
    end
    
    def draw
      @image.draw_rot(@x, @y, @zorder, @angle, @center_x, @center_y, @factor_x, @factor_y, @color, @mode) if @visible
    end
  end  
end