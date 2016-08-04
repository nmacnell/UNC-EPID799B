# gui.R
# Tutorial on how to build a graphical user interface for an R program.
# LearnR! Fall 2014

##### === Part 0: Installing === #####
# Run this install command once to install the package
# This should ask you if you want ot install GTK, click yes!
# after it installs you'll have to restart R.
# Comment out the line below after you get it installed.  

  install.packages("gWidgetsRGtk2")

### If this dosen't work for you, try installing a different toolkit
# install.packages("gWidgetstcltk")  # tcl/tk



##### === Part I: Get the environment set up. === #####
# You'll have to run this each time.
# Library will load the package
# the options() functions tells R which GUI toolkit to use.

### if you installed Gtk
library("gWidgetsRGtk2")
options("guiToolkit"="RGtk2")

### or, the following if you used the tcl/tk toolkit
# library("gWidgetstcltk")
# options("guiToolkit"="tcltk")



##### === Part II: Try some widget components === #####
# Remember we're just building how the interface looks in these examples.
# We'll have to specify what clicking the buttons does later!
# These individual components will be combined in our final program.
# You will recognize many of these widgets - many programmers use these
# as the building blocks of programs (like the GNU image manipulation program,
# for which GTK was developed).
# the container= argument tells where to put the widget.
# gwindow() just makes a new window.

# Print some text in a window
my.label <- glabel("Some text", container = gwindow())

# Make a button to click (won't do anything yet).
my.button <- gbutton("Click me!", container = gwindow())

# Make an editable text field
my.edit <- gedit("Click and edit me!", container = gwindow())

# Make a multiple-choice item
my.radio <- gradio(c("Option 1","Option 2"), container=gwindow())

# Make a drop-down list to select from
my.combobox <- gcombobox(c("Option 1","Option 2"), container=gwindow())

# Display a table of data (click column names to sort)
some.data <- data.frame(name=c("a","b","c"),value=c(3,2,1))
my.table <- gtable(some.data, container=gwindow())

# Checkboxes (multiple choice with multiple or no answers!)
my.checkbox <- gcheckboxgroup(c("hello","world"), container=gwindow())

# Select a value using a slider
my.slider <- gslider(from=0, to = 7734, by =100, value=0,container=gwindow())

# Select a value using more/less with option to enter an exact value
my.spinbutton <- gspinbutton(from=0, to = 7734, by =100, value=0,container=gwindow())

### There are lots of other widget components you can find in the 
# gWidgets manual: http://cran.r-project.org/web/packages/gWidgets/index.html



##### Part III: Putting Components Together #####
# Here we're stitching together multiple widget components in a single window.
# We'll still need to "connect" the buttons to something later,
# so our program won't do anything yet.

### Step 1: Make a "window" object to store everything
# visible=true makes the window appear immediately
# (this is good when you are developing it)

my.window <- gwindow("My Cool R Application", visible=TRUE)

### Step 2: Put in the components
# This is ugly for now, but don't worry (we'll fix it soon!)
# remember not to close the window that pops up from the previous command
# or else you won't get anything.
# Interfaces are built step-wise, just like basic plot()s

some.text <- glabel("Welcome to my cool R program!",container=my.window)
a.textbox <- gedit("Enter your name", container = my.window)
a.button <- gbutton("Hello!",container = my.window) 

##### Part IV: Designing a layout #####
# you can use groups to control layouts.
# Let's NOT arrange things horizontally this time.
# Notice that each component's container is now my.group

my.window <- gwindow("My Cool R Application", visible=TRUE)
my.group <- ggroup(horizontal = FALSE, container=my.window)
some.text <- glabel("Welcome to my cool R program!",container=my.group)
a.textbox <- gedit("Enter your name", container = my.group)
a.button <- gbutton("Hello!",container = my.group)

### You can put groups inside of groups to control the layout.
# here we'll put two buttons next to each other by grouping them together
# into a horizontal group that we put at the bottom of our main group.
window <- gwindow("My Cool R Application", visible=TRUE)
main.group <- ggroup(horizontal = FALSE, container=window)
some.text <- glabel("Welcome to my cool R program!",container=main.group)
a.textbox <- gedit("Enter your name", container = main.group)
button.group <- ggroup(horizontal=TRUE,container=main.group)
a.button <- gbutton("Hello!",container = button.group)
b.button <- gbutton("Bye!",container = button.group)

##### Part V: Adding Handlers
# Handlers allow your program to DO something.
# These are functions that are executed when the user does something.
# technically, whenever the stored value (called "svalue") changes: 
# a button click, a selection change, etc.

### First, define handler functions
# you can use the svalue() function to get the current value of a widget
# svalue() takes one argument: the widget name you defined earlier
# for instance, svalue(username) returns the current value of the text box


say.bye <- function(h, ...) {
	# define a function that does the same thing every time

	# pop up a new window that says bye
	bye.window <- gwindow("Goodbye!",visible=TRUE)
	bye.text <- glabel("Take Care!",container=bye.window)
}

say.hello <- function(h, ...) {
	# we can also do something different by looking at svalue()s
	
	# check if the user has entered a name yet
	if (svalue(username) == "Enter your name") {

		# of not, try to ask the user again for a name
		svalue(welcome.text) <- "I can't greet you without a name!"
	
	# if there IS a name, proceed
	} else {

		# first, build a greeting by pasting two text strings together
		greeting <- paste("Hello",svalue(username))

		# display the user's name
		hello.window <- gwindow("Hello!",visible=TRUE)
		hello.text <- glabel(greeting,container=hello.window)
	}
}

### Next, build our window layout, referencing the handler functions
window <- gwindow("My Cool R Application", visible=TRUE)
main.group <- ggroup(horizontal = FALSE, container=window)
welcome.text <- glabel("Welcome to my cool R program!",container=main.group)
username <- gedit("Enter your name", container = main.group)
button.group <- ggroup(horizontal=TRUE,container=main.group)
a.button <- gbutton("Hello!",container = button.group, handler=say.hello)
b.button <- gbutton("Bye!",container = button.group, handler=say.bye)










