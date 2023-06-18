using Images, ImageSegmentation, Plots,Colors, Clustering, LinearAlgebra

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


#Obtiene etiquetas y el color promedio de cada semilla o región (numberSeeds) de una matriz RGB
function procesarImagen(img::Matrix, numberSeeds::Int)
    n,m = size(img)
    #Preparamos las semillas aleatorias 
    seeds = Tuple{CartesianIndex{2}, Int64}[]
    for i in 1:numberSeeds
        randomSeeds = CartesianIndex(rand(1:n),rand(1:m))
        push!(seeds, (randomSeeds,i))
    end

    #Algoritmo
    segments = seeded_region_growing(img, seeds)
    img_sedeed = map(i->segment_mean(segments,i), labels_map(segments))    #Nueva matriz RGB con las regiones y sus colores

    clases = labels_map(segments)
    clases_mean_color = segment_mean(segments,)
    return img_sedeed,seeds,clases,clases_mean_color
end

function borrar(arr, elemento)
    index = findfirst(x -> x == elemento, arr)
    if index !== nothing
        deleteat!(arr, index)
    end
    return arr
end


function clasify(color)
    if "verde" in color
            borrar(color,"verde")
            if "verde" in color
                    borrar(color,"verde")
                    if "verde" in color
                            return "bosque"  #VERDE VERDE VERDE - BOSQUE
                    elseif "azul" in color
                            return "montana"  #VERDE VERDE AZUL - MONTAÑA
                    elseif  "gris" in color
                            return "motana" #VERDE VERDE GRIS - MONTAÑA
                    end
            elseif "azul" in color
                    borrar(color,"azul")
                    if "gris" in color
                            return "montana"  #VERDE AZUL GRIS    - MONTANA
                    elseif "azul" in color
                            return "playa"  #VERDE AZUL AZUL    - PLAYA
                    elseif "cafe" in color
                        return "montana"  #VERDE azul cafe    - montana
                    end 
            elseif "gris" in color
                borrar(color,"gris")
                if "gris" in color
                    return "montana"  #VERDE GRIS GRIS    - MONTANA
            end 
    end
    end
    if "azul" in color
            borrar(color,"azul")
            if "azul" in color
                    borrar(color,"azul")
                    if "azul" in color
                            return "oceano" #AZUL AZUL AZUL    - OCEANO
                    elseif "gris" in color
                            return "playa"  #AZUL AZUL GRIS    - PLAYA
                    elseif "cafe" in color
                            return "desierto"  #AZUL AZUL CAFE    - DESIERTO
                    end
            elseif "cafe" in color
                    borrar(color,"cafe")
                    if "cafe" in color ||"gris" in color
                            return "desierto"  #AZUL CAFE CAFE    - DESIERTO  
                    end                         #AZUL CAFE GRIS    - DESIERTO  

            end
    end
    if "gris" in color
            borrar(color,"gris")
            if "gris" in color
                    borrar(color,"gris")
                    if "gris" in color
                            return "Bosque nevado" #GRIS GRIS GRIS    - BOSQUE NEVADO 
                    end
            end
    end
    if "cafe" in color
            borrar(color,"cafe")
            if "cafe" in color
                    borrar(color,"cafe")
                    if "cafe" in color || "gris" in color
                            return "desierto" #cafe cafe cafe    - DESIERTO 
                    end                         #cafe cafe gris    - DESIERTO
            end
    end

end

function main()
    img = load("C:/Users/MrJel/Desktop/Felix/Gitthis/AI_L0v3rs/AI_Eng/Digital_Image_Processing/Image Analyzer/Images/montana2.jpg")

    #Se separa en dos procesos para la calidad de las agrupacinoes 
    #Se segmenta para 300 smillas, así miles de tonos que tiene una imagen se pasan a solo 300 tonos
    #Se segmenta para 3 semillas, de 300 tonos solo pasará a 3
    
    #La segmentación será de mejor calidad si se empieza segmentando con muchas semillas y poco a poco se reduce la cantidad de semillas
    num_semillas = 300
    num_clases = 3

    img_sedeed, seeds1,a,b = procesarImagen(img, num_semillas)
    img_sedeed_clasified, seeds2, labelMap, colorClases= procesarImagen(img_sedeed, num_clases)

    #Inicializa diccionario de las regiones etiquetadas con 0 puntos en cada clase (región o clase, cantidadPuntos)
    region_dict = Dict{Int8, Int}()
    for i in 1:num_clases
        setindex!(region_dict,0,i)
    end

    #PORCENTAJE DE PUNTOS EN CADA REGIÓN
    coordenadas = []
    
    for (cartesianC,_) in seeds1
        num_region = labelMap[cartesianC[1],cartesianC[2]]   #Ubica el numero de región en las coordenadas de la semilla 
        region_dict[num_region] = region_dict[num_region]+1   #Aumenta el valor de esa region 

        push!(coordenadas, (cartesianC[2],cartesianC[1])) #coordenadas de las semillas
    end

    pointsClass1 = (region_dict[1]/num_semillas)*100
    pointsClass2 = (region_dict[2]/num_semillas)*100
    pointsClass3 = (region_dict[3]/num_semillas)*100

    print("Puntos en la region 1: $pointsClass1% \n Puntos en la region 2: $pointsClass2% \n Puntos en la region 3: $pointsClass3%\n")

    #Visualizar puntos (no funciona )
    #tamano = 5 
    #color = :red
    #plot(img_sedeed_clasified)
    #scatter!([p[1] for p in coordenadas], [p[2] for p in coordenadas], markersize = tamano, markercolor = color, legend = false)

    #Resultados
    # imshow(img_sedeed_clasified)
    #imshow(img)
    #imshow(img_sedeed)
    

    #Detección de color 
    colorsImage =[]
    for clave in keys(colorClases) #Obtiene el promedio de color de cada region generada

        valor = colorClases[clave] #Color de la region
        valorRGB = [convert(Int,round(valor.r*255)), convert(Int,round(valor.g*255)), convert(Int,round(valor.b*255))] #Convierte RGB{float32} a Uint8
        nombreDeColor = getColor(valorRGB)
        
        print("El valor $valorRGB es el color $nombreDeColor \n")
        push!(colorsImage, nombreDeColor)
        end
    
    escena = clasify(colorsImage)
    print("La escena es: $escena \n")

end



using Images, ImageView

img = load("C:/Users/MrJel/Desktop/Felix/Gitthis/AI_L0v3rs/AI_Eng/Digital_Image_Processing/Image Analyzer/Images/montana2.jpg")


using ImageSegmentation
seeds = [(CartesianIndex(126,81),1), (CartesianIndex(93,255),2), (CartesianIndex(213,97),3)]
segments = seeded_region_growing(img, seeds)