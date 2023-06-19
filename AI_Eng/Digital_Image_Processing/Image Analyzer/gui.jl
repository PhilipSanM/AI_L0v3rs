using Gtk, Plots, Images, ImageSegmentation, ImageIO, Images, ImageSegmentation, Colors, Clustering, LinearAlgebra

# Algorithm
function borrar(arr, elemento)
    index = findfirst(x -> x == elemento, arr)
    if index !== nothing
        deleteat!(arr, index)
    end
    return arr
end

#KNN: Obtiene el nombre del RGB 
function getColor(color)

    #Datos de entrenamiento, ajustar si es necesario
    verde = [110,170,50]
    azul = [70, 146, 200]

    #El rango de los grises en las imagenes es amplio, asi que se usa una parte cercana a los blancos y otra a los negros
    blanco = [170,170,170]
    negro = [80,80,80]


    cafe = [212,141,0]
    
    
    green_distance = sqrt((verde[1] - color[1])^2 + (verde[2] - color[2])^2 + (verde[3] - color[3])^2)
    blue_distance = sqrt((azul[1] - color[1])^2 + (azul[2] - color[2])^2 + (azul[3] - color[3])^2)
    #gris abarca negro y blanc
    grey_distance_1 = sqrt((blanco[1] - color[1])^2 + (blanco[2]  - color[2])^2 + (blanco[3]  - color[3])^2)
    grey_distance_2 = sqrt((negro[1]- color[1])^2 + (negro[2] - color[2])^2 + (negro[3] - color[3])^2)
    
    coffe_distance = sqrt((cafe[1]- color[1])^2 + (cafe[2] - color[2])^2 + (cafe[3] - color[3])^2)

    grey_distance_mean = (grey_distance_1 + grey_distance_2)/2

    minimo = min(green_distance,blue_distance,grey_distance_mean,coffe_distance)
    #print("\n$green_distance \n $blue_distance \n $grey_distance_mean \n $coffe_distance \n ")

    if minimo==green_distance
        return "verde"
    elseif minimo==blue_distance
        return "azul"
    elseif minimo==grey_distance_mean 
        return "gris"
    elseif minimo==coffe_distance
        return "cafe"
    else
        return "error"
    end
end


#Con un arbol de decisión se puede optimizar esta función
function clasify(color)
    if "verde" in color
        borrar(color, "verde")
        if "verde" in color
            borrar(color, "verde")
            if "verde" in color
                return "un bosque"  #VERDE VERDE VERDE - BOSQUE
            elseif "azul" in color
                return "una montana"  #VERDE VERDE AZUL - MONTAÑA
            elseif "gris" in color
                return "una motana" #VERDE VERDE GRIS - MONTAÑA
            end
        elseif "azul" in color
            borrar(color, "azul")
            if "gris" in color
                return "una montana"  #VERDE AZUL GRIS    - MONTANA
            elseif "azul" in color
                return "una playa"  #VERDE AZUL AZUL    - PLAYA
            elseif "cafe" in color
                return "una montana"  #VERDE azul cafe    - montana
            end
        elseif "gris" in color
            borrar(color, "gris")
            if "gris" in color
                return "una montana"  #VERDE GRIS GRIS    - MONTANA
            end
        end
    end
    if "azul" in color
        borrar(color, "azul")
        if "azul" in color
            borrar(color, "azul")
            if "azul" in color
                return "un oceano" #AZUL AZUL AZUL    - OCEANO
            elseif "gris" in color
                return "una playa"  #AZUL AZUL GRIS    - PLAYA
            elseif "cafe" in color
                return "un desierto"  #AZUL AZUL CAFE    - DESIERTO
            end
        elseif "cafe" in color
            borrar(color, "cafe")
            if "cafe" in color || "gris" in color
                return "un desierto"  #AZUL CAFE CAFE    - DESIERTO  
            end                         #AZUL CAFE GRIS    - DESIERTO  

        end
    end
    if "gris" in color
        borrar(color, "gris")
        if "gris" in color
            borrar(color, "gris")
            if "gris" in color
                return "un bosque nevado" #GRIS GRIS GRIS    - BOSQUE NEVADO 
            end
        end
    end
    if "cafe" in color
        borrar(color, "cafe")
        if "cafe" in color
            borrar(color, "cafe")
            if "cafe" in color || "gris" in color
                return "un desierto" #cafe cafe cafe    - DESIERTO 
            end                         #cafe cafe gris    - DESIERTO
        end
    end

end

# GUI
function createGui()
    gui = GtkWindow("I L0v3 U jUl14", 500, 500)
    grid = GtkGrid()
    # Image in the center, two buttons at the bottom and a label at the top
    img_path0 = abspath(".//AI_Eng//Digital_Image_Processing//Image Analyzer//Images//cat0.jpg")
    img_path1 = abspath(".//AI_Eng//Digital_Image_Processing//Image Analyzer//Images//cat1.jpg")
    img_path3 = abspath(".//AI_Eng//Digital_Image_Processing//Image Analyzer//Images//cat3.jpg")
    img_path2 = abspath(".//AI_Eng//Digital_Image_Processing//Image Analyzer//Images//cat2.jpg")

    
    imgGtkCat0 = GtkImageLeaf(img_path0)
    imgGtkCat1 = GtkImageLeaf(img_path1)
    imgGtkCat2 = GtkImageLeaf(img_path2)
    imgGtkCat3 = GtkImageLeaf(img_path3)
    
    exitButton = GtkButton("Exit")
    startButton = GtkButton("Start")

    
    loadImageMenu = GtkComboBoxText()
    choices = ["desert.jpg", "forest.jpg", "mountain.jpg", "beach.jpg"]
    for choice in choices
        push!(loadImageMenu,choice)
    end
    # Lets set the active element to be "two"
    set_gtk_property!(loadImageMenu,:active,0)


    label = GtkLabel("miuajuuaua")
    GAccessor.justify(label, Gtk.GConstants.GtkJustification.CENTER)

    set_gtk_property!(grid, :column_homogeneous, true)
    set_gtk_property!(grid, :row_spacing, 15)  # introduce a 15-pixel gap between columns
    
    grid[1,1] = imgGtkCat0
    grid[1,2] = imgGtkCat2
    grid[2,1] = imgGtkCat1
    grid[2,2] = imgGtkCat3

    grid[2,3] = label
    grid[1,3] = loadImageMenu
    grid[1,4] = startButton
    grid[1,5] = exitButton

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

    
        function procesarImagen(img::Matrix, numberSeeds::Int)
            n, m = size(img)
            #Preparamos las semillas aleatorias 
            seeds = Tuple{CartesianIndex{2},Int64}[]
            for i in 1:numberSeeds
                randomSeeds = CartesianIndex(rand(1:n), rand(1:m))
                push!(seeds, (randomSeeds, i))
            end

            #Algoritmo
            segments = seeded_region_growing(img, seeds)
            img_sedeed = map(i -> segment_mean(segments, i), labels_map(segments))    #Nueva matriz RGB con las regiones y sus colores

            clases = labels_map(segments)
            clases_mean_color = segment_mean(segments,)
            return img_sedeed, seeds, clases, clases_mean_color
        end


        img = load(img_path)
        num_semillas = 300
        num_clases = 3
        img_sedeed, seeds1 = procesarImagen(img, num_semillas)
        img_sedeed_clasified, seeds2, labelMap, colorClases = procesarImagen(img_sedeed, num_clases)


        img_result_path = abspath(".//AI_Eng//Digital_Image_Processing//Image Analyzer//Images//result.jpg")


        Images.save(img_result_path, img_sedeed_clasified)

        new_img_3 = GtkImageLeaf(img_result_path)
        #Inicializa diccionario de las regiones etiquetadas con 0 puntos en cada clase (región o clase, cantidadPuntos)
        region_dict = Dict{Int8,Int}()
        for i in 1:num_clases
            setindex!(region_dict, 0, i)
        end

        #PORCENTAJE DE PUNTOS EN CADA REGIÓN
        coordenadas = []

        for (cartesianC, _) in seeds1
            num_region = labelMap[cartesianC[1], cartesianC[2]]   #Ubica el numero de región en las coordenadas de la semilla 
            region_dict[num_region] = region_dict[num_region] + 1   #Aumenta el valor de esa region 

            push!(coordenadas, (cartesianC[2], cartesianC[1])) #coordenadas de las semillas
        end

        pointsClass1 = round(((region_dict[1] / num_semillas) * 100), digits=2)
        pointsClass2 = round(((region_dict[2] / num_semillas) * 100), digits=2)
        pointsClass3 = round(((region_dict[3] / num_semillas) * 100), digits=2)



        #Detección de color 
        colorsImage = []
        for clave in keys(colorClases) #Obtiene el promedio de color de cada region generada

            valor = colorClases[clave] #Color de la region
            valorRGB = [convert(Int, round(valor.r * 255)), convert(Int, round(valor.g * 255)), convert(Int, round(valor.b * 255))] #Convierte RGB{float32} a Uint8
            nombreDeColor = getColor(valorRGB)
            push!(colorsImage, nombreDeColor)
        end
        escena = clasify(colorsImage)

        #plot de puntos
        tamano = 5 
        color = :red
        plot(img_sedeed_clasified, size=(300, 300))
        scatter!([p[1] for p in coordenadas], [p[2] for p in coordenadas], markersize = tamano, markercolor = color, legend = false)
        
        ruta_archivo = "C:/Users/Brandom/Documents/1Proyectopdi/PUNTOS.png"
        
        
        img_points_path = abspath(".//AI_Eng//Digital_Image_Processing//Image Analyzer//Images//points.png")
        savefig(img_points_path)

        new_img_2 = GtkImageLeaf(img_points_path)

    
        imgGtkCat0 = GtkImageLeaf(img_path0)


        # Removing previous widget in the first cell
        destroy(grid[1, 1])
        destroy(grid[1, 2])
        destroy(grid[2, 1])
        # Adding new image widget to the first cell
        grid[1, 1] = new_img
        grid[1, 2] = new_img_2
        grid[2, 1] = new_img_3



        #Changing text
        GAccessor.text(label, "\nPuntos en la region 1: $pointsClass1%\n Puntos en la region 2: $pointsClass2% \n Puntos en la region 3: $pointsClass3%\n\n\n Se trata de $escena")
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
   createGui()
end

main()

