#Minimal Gtk/Cairo module; introducing Cairo in Tutorial I'm writing on Hiki, where
# Hiki="http://ruby-gnome2.sourceforge.jp/hiki.cgi?c=view;p=tut-gtk2-dancr-rbcatut"
#
# FILE: hiki2-gtk-w-cairo.rb
# RELEASE: 1.2

module HikiGtk
require 'gtk2'
require 'cairo'

class BasicWindow < Gtk::Window
	def initialize(title = nil)
		super(Gtk::Window::TOPLEVEL)
		set_title(title) if title
		set_size_request(250, 200)
		border_width = 10
		signal_connect("key_press_event") do |widget, event|
			if event.keyval == Gdk::Keyval::GDK_q
				quit
				true # don't propagate event
			else
				false # event ins't treat here. Propagation to the next widget allowed.
			end
		end
		signal_connect("delete_event") { |widget, event| quit }
		signal_connect("destroy") { Gtk.main_quit }
		puts "DEBUG:initialize completed in class BasicWindow"
	end
	def quit
		puts "DEBUG: quiting Hiki example"
		destroy
		false
	end
end

class CairoWindow < BasicWindow
	PI = Math::PI
	RAD2DEG = 180/PI
	DEG2RAD = PI/180

	BLACK=[0,0,0];     RED=[1,0,0];  GREEN=[0,1,0];  BLUE=[0,0,1]; 
	TURQUOISE=[0,1,1]; PINK=[1,0,1]; YELLOW=[1,1,0]; WHITE=[1,1,1]
	GRAY=[0.8,0.8,0.8]

	def initialize(title=nil)
		super title
		unless Gdk.cairo_available?
			raise "This program requires GTK+ 2.8.0 or later and cairo support"
		end
		drawing_area = Gtk::DrawingArea.new
		add(drawing_area)
		drawing_area.signal_connect("expose_event") do |w, e|
			cr = w.window.create_cairo_context
			cr.rectangle(e.area.x, e.area.y, e.area.width, e.area.height)
			cr.clip()
			draw(cr, w)
		end
		puts "DEBUG:initialize completed in class CairoWindow"
	end
	def draw(cr, drawing_area)
		width, height = drawing_area.window.size
		# Fill the background with gray
		cr.set_source_rgb(GRAY)
		cr.rectangle(0, 0, width, height)
		cr.fill()
	end
end
end # of module HikiGtk




