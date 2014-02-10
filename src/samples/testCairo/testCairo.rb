load 'hiki2-gtk-w-cairo.rb'
include HikiGtk

class SmileyFace < CairoWindow
  def draw(cr, drawing_area)

	width, height = drawing_area.window.size

	# ---------------------
	# Fill the background with a colour of your choice
	cr.set_source_rgb(0.5, 0.5, 0.9)
	cr.rectangle(0, 0, width, height)
	cr.fill
	# draw a rectangle
	cr.set_source_rgb(1.0, 1.0, 1.0)
	cr.rectangle(10, 10, width - 20, height - 20)
	cr.fill
	# and a circle
	cr.set_source_rgb(1.0, 0.0, 0.0)
	radius = [width, height].min
	cr.arc(width / 2.0, height / 2.0, radius / 2.0 - 20, 0, 2 * Math::PI)
	cr.stroke
	cr.arc(width / 2.0, height / 2.0, radius / 3.0 - 10, Math::PI / 3, 2 * Math::PI / 3)
	cr.stroke
	# draw lines
	cr.set_source_rgb(0.0, 0.0, 0.8)
	cr.move_to(width / 3.0, height / 3.0)
	cr.rel_line_to(0, height / 6.0)
	cr.move_to(2 * width / 3.0, height / 3.0)
	cr.rel_line_to(0, height / 6.0)
	cr.stroke
	# ---------------------
  end
end

w=SmileyFace.new("Smiley Face")
w.show_all
w.set_size_request(75, 50)
Gtk.main
