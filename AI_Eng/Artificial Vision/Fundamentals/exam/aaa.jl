
using PlotlyJS, Statistics, LinearAlgebra

# Mahalanobis x::vector desconocido, m::vector medias, mcov::matriz de covarianza 
get_mahalanobis_distance(point,means,mcov) = sqrt((point-means')*mcov*(point-means')')

graficar(x,y,z,color,nombre,modo) = scatter3d(
                                            x=x, y=y, z=z, 
                                            color=color, 
                                            name=nombre, 
                                            mode=modo)


get_eucledian_distance(pointA, pointB) = sqrt(sum((pointA .- pointB).^2))



euclidean_distance(point1, point2) = sqrt(sum((point1 .- point2).^2))
    

function get_max_prob_distance(x,m,mcov)
    dato1 =  ℯ^(-(get_mahalanobis_distance(x, m, inv(mcov))))
    dato2 = 1 / ((2*π^(3/2)) * det(mcov)^(-(1/2)))
    return dato1 * dato2
end

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



graficar2d(x,y,nombre,modo,color) = scatter(x=x, y=y, name=nombre, mode=modo, color=color)


function main()
    cords_c1 = [1 2;
                0 0]
    #Cordenadas clase 2
    cords_c2 = [-2 -1;
                0 -2]
    
    mean1 = [mean(cords_c1[1,:])
            mean(cords_c1[2,:])]

    mean2 = [mean(cords_c2[1,:])
            mean(cords_c2[2,:])]

    # cov1 = inv(cov([cords_c1[1,:] cords_c1[2,:]], corrected=false))
    # cov2 = inv(cov([cords_c2[1,:] cords_c2[2,:]], corrected=false))

    println("Dame el punto x y")
    punto = readline()
    p_cords = parse.(Float64, split(punto, " ", limit=6))'

    point = [p_cords[1]; p_cords[2]]

    trace1 = graficar2d(cords_c1[1,:], cords_c1[2,:], "Clase 1", "markers", :red)
    trace2 = graficar2d(cords_c2[1,:], cords_c2[2,:], "Clase 2", "markers", :green)

    trace3 = graficar2d([point[1]], [point[2]], "Punto", "markers", :blue)

    display(plot([trace3, trace2, trace1]))

    classes = Dict("Clase 1" => cords_c1, "Clase 2" => cords_c2)



    choice = 0

    while choice != 5
        println("\nSelect a distance measure:")
        println("1. Euclidean Distance")
        println("2. Mahalanobis Distance")
        println("3. Maxima Probabilidad Distance")
        println("4. KNN")
        println("5. Quit")
        print("\nEnter your choice: ")
        choice = parse(Int, readline())

        if choice == 1
            println("You selected Euclidean Distance.")
            euclidian_classification(mean1, mean2, point)
            
        elseif choice == 2
            println("You selected Mahalanobis Distance.")
            euclidian_classification(mean1, mean2, point)
        elseif choice == 3
            println("You selected maxprob Distance.")
            euclidian_classification(mean1, mean2, point)
        elseif choice == 4
            println("You selected KNN Distance.")
            knn_classification(classes, p_cords)
        elseif choice == 5
            println("Exiting the program.")
        else
            println("Invalid choice. Please select a valid option.")
        end
    end




end


function euclidian_classification(mean1, mean2, p_cords)
    println("euclidean_distance:  ")
    d = Dict( "Clase 1" => euclidean_distance(p_cords, mean1), "Clase 2" => euclidean_distance(p_cords, mean2));
    min = minimum(values(d));

    for (k, v) = d
        if (v == min)
            println("\n\nEl pixel seleccionado pertenece a la $k")
            break
        end
    end 


end

function mahalanobis_classification(clases, point)
    println("mahalanobis_classification")


end


function knn_classification(classes, p_cords)
    println("knn_classification")

    K = 3

    println("Enter K")
    K = parse.(Int64, readline())

    predicted_class = predict_using_knn(K, classes, p_cords)
    println("\n\nEl pixel seleccionado pertenece a la $predicted_class")

end
    
function max_prob_classification(clases, point)
    println("max_prob_classification")

end


function select_vector_eu()
    while true
        println("Enter coordinates: x,y")
        punto = readline()
        p_cords = parse.(Float64, split(punto, ",", limit=2))'
  
            d = Dict( "Clase 1" => euclidean_distance(p_cords, mean1), "Clase 2" => euclidean_distance(p_cords, mean2));
            min = minimum(values(d));
    
            for (k, v) = d
                if (v == min)
                    println("\n\nEl pixel seleccionado pertenece a la $k")
                    break
                end
            end 

            trace3 = graficar2d([p_cords[1]], [p_cords[2]], :pink, "Unknown", "markers")
            display(plot([trace1, trace2, trace3], layout))


        println("\n\nSi deseas salir del programas ingresa 'q' ");
        input = readline(stdin);
        if input == "q"
            break
        end  
    end
end

