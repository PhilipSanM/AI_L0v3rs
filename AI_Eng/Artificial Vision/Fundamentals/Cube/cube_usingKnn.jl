#     INSTITUTO POLITÉCNICO NACIONAL
#     ESCUELA SUPERIOR DE COMPUTO
#     VISION ARTIFICIAL
#     PRACTICA 1 - PERTENECE AL CUBO 

using PlotlyJS, Statistics

# Mahalanobis x::vector desconocido, m::vector medias, mcov::matriz de covarianza 
get_mahalanobis_distance(point,means,mcov) = sqrt((point-means')mcov(point-means')')

graficar(x,y,z,color,nombre,modo) = scatter3d(
                                            x=x, y=y, z=z, 
                                            color=color, 
                                            name=nombre, 
                                            mode=modo)


get_eucledian_distance(pointA, pointB) = sqrt(sum((pointA .- pointB).^2))
    

function find_k_nearest_neighbors(k, classes, point)
    distances = Dict()

    for (key, cords) = classes
        for cord in eachcol(cords)
            distance = get_eucledian_distance(point, cord)
            distances[(key, cord)] = distance
        end
    end

    distances = sort(collect(distances), by=x->x[2])

    return distances[1:k]
end

function predict_using_knn(k, classes, point)
    k_nn = find_k_nearest_neighbors(k, classes, point)

    votes = Dict("Clase 1" => 0, "Clase 2" => 0)

    for (key, value) = k_nn
        votes[key[1]] += 1
    end

    predicted_class = ""

    max_class = maximum(values(votes))
    for (key, value) = votes
        if (value == max_class)
            predicted_class = key
            break
        end
    end

    return predicted_class
    
end

                        
function main()
    #Cordenadas clase 1
    cords_c1 = [0 1 1 1;
                0 0 0 1;
                0 0 1 0]
    #Cordenadas clase 2
    cords_c2 = [0 0 1 0;
                0 1 1 1;
                1 1 1 0]
    
    mean1 = [mean(cords_c1[1,:])
            mean(cords_c1[2,:])
            mean(cords_c1[3,:])]

    mean2 = [mean(cords_c2[1,:])
            mean(cords_c2[2,:])
            mean(cords_c2[3,:])]

    cov1 = inv(cov([cords_c1[1,:] cords_c1[2,:] cords_c1[3,:]], corrected=false))
    cov2 = inv(cov([cords_c2[1,:] cords_c2[2,:] cords_c2[3,:]], corrected=false))

    layout = Layout(title="Scatter Plot")
    trace1 = graficar([cords_c1[1,:]; mean1[1]], [cords_c1[2,:]; mean1[2]], [cords_c1[3,:]; mean1[3]], :red3, "Class 1", "markers+lines")
    trace2 = graficar([cords_c2[1,:]; mean2[2]], [cords_c2[2,:]; mean2[2]], [cords_c2[3,:]; mean2[3]], :blue, "Class 2", "markers+lines" )

    classes = Dict("Clase 1" => cords_c1, "Clase 2" => cords_c2)


    while true
        println("Enter coordinates: x,y,z")
        punto = readline()
        p_cords = parse.(Float64, split(punto, ",", limit=3))'

        if 0≤p_cords[1]≤1 && 0≤p_cords[2]≤1 && 0≤p_cords[3]≤1
            
            distances = Dict( "Clase 1" => get_mahalanobis_distance(p_cords, mean1, cov1), "Clase 2" => get_mahalanobis_distance(p_cords, mean2, cov2));
            min = minimum(values(distances));
    
            for (key, value) = distances
                if (value == min)
                    println("\n\nEl pixel seleccionado pertenece a la $key")
                    break
                end
            end 

            trace3 = graficar([p_cords[1]], [p_cords[2]], [p_cords[3]], :green, "Unknown", "markers")
           
        else
            println("El punto seleccionado se encuentra fuera del cubo")
        end


        
        if 0≤p_cords[1]≤1 && 0≤p_cords[2]≤1 && 0≤p_cords[3]≤1
            
            K = 5
            predicted_class = predict_using_knn(K, classes, p_cords)
            println("\n\nEl pixel seleccionado pertenece a la $predicted_class")

            trace3 = graficar([p_cords[1]], [p_cords[2]], [p_cords[3]], :green, "Unknown", "markers")
            display(plot([trace1, trace2, trace3], layout))
        else
            println("El punto seleccionado se encuentra fuera del cubo")
        end


        println("\n\nSi deseas salir del programas ingresa 'q' ");
        input = readline(stdin);
        if input == "q"
            break
        end  
    end

end