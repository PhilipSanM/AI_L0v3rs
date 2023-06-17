using Gtk, Plots, Images, ImageSegmentation, ImageIO



function createGui(img_path)
    gui = GtkWindow("I L0v3 U jUl14", 500, 500)
    grid = GtkGrid()
    # Image in the center, two buttons at the bottom and a label at the top
    
    imgGtk = GtkImageLeaf(img_path)
    
    exitButton = GtkButton("Exit")
    startButton = GtkButton("Start")

    
    loadImageMenu = GtkComboBoxText()
    choices = ["cat.jpg", "desert.jpg", "forest.jpg", "mountain.jpg", "beach.jpg"]
    for choice in choices
        push!(loadImageMenu,choice)
    end
    # Lets set the active element to be "two"
    set_gtk_property!(loadImageMenu,:active,0)


    label = GtkLabel("miuajuuaua")
    GAccessor.justify(label, Gtk.GConstants.GtkJustification.CENTER)

    set_gtk_property!(grid, :column_homogeneous, true)
    set_gtk_property!(grid, :row_spacing, 15)  # introduce a 15-pixel gap between columns
    
    grid[1,1] = imgGtk
    grid[2,1] = label
    grid[1,2] = loadImageMenu
    grid[1,3] = startButton
    grid[1,4] = exitButton

    set_gtk_property!(grid, :column_homogeneous, true)
    set_gtk_property!(grid, :column_spacing, 15)  # introduce a 15-pixel gap between columns
    push!(gui, grid)

    

    # Handlers
    function exitHandler(button)
        destroy(gui)
        exit(0)
    end
    
    function startHandler(button)
        str = Gtk.bytestring( GAccessor.active_text(loadImageMenu) )
        println("poniendo la foto del: \"$str\"" )
        img_path = abspath(".//AI_Eng//Digital_Image_Processing//Image Analyzer//Images//$str")
        new_img = GtkImageLeaf(img_path)

        #Changing text
        GAccessor.text(label, "Imagen de un \"$str\"")
        

        # Removing previous widget in the first cell
        destroy(grid[1,1])

        # Adding new image widget to the first cell
        grid[1, 1] = new_img

        Gtk.showall(gui)
    
    end

    function loadHandler(botton)
        idx = get_gtk_property(loadImageMenu, "active", Int)
        # get the active string 
        # We need to wrap the GAccessor call into a Gtk bytestring
        str = Gtk.bytestring( GAccessor.active_text(loadImageMenu) )
        println("Active element is \"$str\" at index $idx")
    end

    # Connectors
    signal_connect(exitHandler, exitButton, "clicked")
    signal_connect(startHandler, startButton, "clicked")
    signal_connect(loadHandler,loadImageMenu, "changed") 

    showall(gui)
end



function main()
    img_path = abspath(".//AI_Eng//Digital_Image_Processing//Image Analyzer//Images//cat.jpg")
   createGui(img_path)
end

main()

