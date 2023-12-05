# K-means applied in Images


using TestImages, Images, ImageView, Random, Gtk4

import Gtk4.open_dialog as dig

mutable struct Centroid
    closest_points::Array{Int64,1}
    location::Array{Float64,1}
end

show_img(image, title) = return imshow(image, canvassize=(600, 600))

function get_k_means(features_map::Dict{Int64,Array{Float64,1}}, k::Int64, num_dimensions::Int64, distance_function::Function, max_iterations::Int64)
    # returns the location of the k centroids

    # Random selection of the initial centroids without repetition
    initial_centroid_users = Set{Int64}()
    
    for (key, value) in pairs(features_map)
        push!(initial_centroid_users, key)
    end

    centroids = [Centroid([], features_map[pop!(initial_centroid_users)]) for i in 1:k]

    # print("INICIALIZACION CENTROIODES: ", [centroid.location for centroid in centroids])

    for i in 1:max_iterations
        # println("Iteration: ", i)

        # Calculate the closest centroid for each point
        for (key, features) in pairs(features_map)
            closest_centroid = nothing

            closest_distance = Inf
            for centroid in centroids
                curr_distnace = distance_function(centroid.location, features)
                if curr_distnace < closest_distance
                    closest_distance = curr_distnace
                    closest_centroid = centroid
                end
            end
            push!(closest_centroid.closest_points, key)

        end

        # Updating location of the centroids
        for centroid in centroids
            centroid.location = get_average(centroid, features_map, num_dimensions)

            # Clear again the closest points
            centroid.closest_points = []
        end
        # print(" CENTROIODES: ", [centroid.location for centroid in centroids])

        


    end

    return [centroid.location for centroid in centroids]
end


function get_eculidean_distance(point1::Array{Float64,1}, point2::Array{Float64,1})
    # returns the eculidean distance between two points
    return sqrt(sum((point1 - point2).^2))
end

function getn_manhatan_distance(point1::Array{Float64,1}, point2::Array{Float64,1})
    # returns the manhatan distance between two points
    distance = 0
    for i in 1:length(point1)
        distance += abs(point1[i] - point2[i])
    end

end
    
function get_average(centroid, features_map,num_dimensions)
    # returns the average of the points in the centroid
    average = zeros(num_dimensions)
    for point in centroid.closest_points
        average += features_map[point]
    end
    return average/length(centroid.closest_points)
end



function main()
    # runninng the k-means algorithm
    
    # Loading the image
    # Seleccion de imagen
    path::String = dig("Pick a File"; start_folder = "C:/Users/MrJel/Desktop/Felix/Gitthis/AI_L0v3rs/AI_Eng/Artificial Vision/Images")
    
    img = load(path)
    
    # Generating Points:

    println("Cuantos puntos random quieres generar?")
    n_points = parse(Int64, readline())

    features_map = Dict{Int64,Array{Float64,1}}()
    for i in 1:n_points
        x = rand(1:size(img, 1))
        y = rand(1:size(img, 2))
        push!(features_map, i => [x, y])
        # println("Punto $i: ", features_map[i])
    end
    # print("Shape of image", size(img))

    # Img with points:
    img_with_points = copy(img)
    for (key, value) in pairs(features_map)
        
        color = RGB{N0f8}(1,0,0)
        img_with_points[round(Int, value[1]), round(Int, value[2])] = color
        # create_bigger_dots(img_with_points, value, color)
        create_bigger_dots(img_with_points, value, color)

    end

    show_img(img_with_points, "Points")

    # Running the algorithm
    println("Cuantos clusters quieres?")
    k = parse(Int64, readline())
    num_dimensions = 2
    max_iterations = 1000
    centroids = get_k_means(features_map, k, num_dimensions, get_eculidean_distance, max_iterations)

    # Img with centroids:
    img_with_centroids = copy(img_with_points)
    println("Centroids: ", centroids)
   
    for centroid in centroids
        img_with_centroids[round(Int, centroid[1]), round(Int, centroid[2])] = RGB{N0f8}(0, 0, 0)

        # create_bigger_dots(img_with_centroids, centroid, RGB{N0f8}(0, 1, 0))
        create_bigger_dots(img_with_centroids, centroid, RGB{N0f8}(1, 1, 1), 6)
    end

    show_img(img_with_centroids, "Centroids")


    # Plotting the 3 Image
  





end


function create_bigger_dots(img, coordinates, color, neighborhood_size=1)
    m, n = size(img)
    x, y = round.(Int, coordinates)
    
    for i in max(1, x-neighborhood_size):min(m, x+neighborhood_size)
        for j in max(1, y-neighborhood_size):min(n, y+neighborhood_size)
            img[i, j] = color
        end
    end
end