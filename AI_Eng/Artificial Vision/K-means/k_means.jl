# K-means applied in Images


using TestImages, Images, ImageView, Random, PlotlyJS

import Gtk4.open_dialog as dig

mutable struct Centroid
    closest_points::Array{Int64,1}
    location::Array{Float64,1}
end

show_img(image, title) = return imshow(image, canvassize=(600, 600))

graficate_3d(x,y,z,color,nombre,modo) = scatter3d(
                                            x=x, y=y, z=z, 
                                            color=color, 
                                            name=nombre, 
                                            mode=modo)

function get_k_means(features_map::Dict{Int64,Array{Float64,1}}, k::Int64, distance_function::Function, max_iterations::Int64, num_dimensions::Int64)
    # returns the location of the k centroids
    

    # Random selection of the initial centroids without repetition
    initial_centroid_users = Set{Array{Float64,1}}()
    
    for (key, value) in pairs(features_map)
        push!(initial_centroid_users, value)
    end
    # print(initial_centroid_users)

    centroids = [Centroid([], pop!(initial_centroid_users)) for i in 1:k]

    # println("INICIALIZACION CENTROIODES: ", [centroid.location for centroid in centroids])
    plots_in_iterations = []

    for i in 1:max_iterations
        # Clear points
        for centroid in centroids
            
            centroid.closest_points = []
        end
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

        end
        # println(" CENTROIODES: ", [centroid.location for centroid in centroids])


        # TODO
        # Aqui vendria tomar las capturas de los plots ;v y seria copiar el como las trace


            # Plotting the 3 Image
        # colors = [:red3, :blue, :green, :yellow, :orange, :purple, :pink, :brown, :black, :white]
        # traces = []

        
        # for i in 1:k
        #     trace = graficate_3d([centroids[i].location[1]], [centroids[i].location[2]], [centroids[i].location[3]], colors[i], "Centroid $i", "markers")
            
        #     push!(traces, trace)

        #     dimension_points = [[] for i in 1:num_dimensions]
            
        #     # Points in the centroid
        #     for point in centroids[i].closest_points
        #         # trace = graficate_3d([features_map[point][1]], [features_map[point][2]], [features_map[point][3]], colors[i], "Point $point", "markers")
        #         # push!(centroid_traces, trace)
        #         for j in 1:num_dimensions
        #             push!(dimension_points[j], features_map[point][j])
        #         end

        #     end
        #     trace = graficate_3d(dimension_points[1], dimension_points[2], dimension_points[3], colors[i], "Points in Centroid $i", "markers")
        #     push!(traces, trace)
        # end

        # l = Layout(title="Scatter Plot")
        # push!(plots_in_iterations, plot([trace for trace in traces], l))

        # XD Nose si se pueda eso pero ya toma emi
        

        


    end

    return centroids, plots_in_iterations
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
    coordinates_in_img = Dict{Int64,Array{Float64,1}}()
    for i in 1:n_points
        x = rand(1:size(img, 1))
        y = rand(1:size(img, 2))
        push!(features_map, i => [Float64.(red.(img[x, y])), Float64.(green.(img[x, y])), Float64.(blue.(img[x, y]))])
        # println("Punto $i: ", features_map[i])

        push!(coordinates_in_img, i => [x,y])
    end
    # print("Shape of image", size(img))
    num_dimensions = length(features_map[1])

    # Img with points:
    img_with_points = copy(img)
    for (key, value) in pairs(coordinates_in_img)
        
        color = RGB{N0f8}(1,0,0)
        img_with_points[round(Int, value[1]), round(Int, value[2])] = color
        # create_bigger_dots(img_with_points, value, color)
        # create_bigger_dots(img_with_points, value, color)

    end

    show_img(img_with_points, "Points")

    # Running the algorithm
    println("Cuantos clusters quieres?")
    k = parse(Int64, readline())



    max_iterations = 1000
    centroids, plots = get_k_means(features_map, k, get_eculidean_distance, max_iterations, num_dimensions)

    # Img with centroids:
    
    # println("Centroids: ", centroids)
    # [[0.7372549019607844, 0.803921568627451, 0.9882352941176471], [0.1568627450980392, 0.34901960784313724, 0.8705882352941177], [0.9607843137254902, 0.8784313725490196, 0.5450980392156862]]


    # Plotting the 3 Image
    colors = [:red3, :blue, :green, :yellow, :orange, :purple, :pink, :brown, :black, :white]
    traces = []

    
    for i in 1:k
        trace = graficate_3d([centroids[i].location[1]], [centroids[i].location[2]], [centroids[i].location[3]], colors[i], "Centroid $i", "markers")
        
        push!(traces, trace)

        dimension_points = [[] for i in 1:num_dimensions]
        
        # Points in the centroid
        for point in centroids[i].closest_points
            # trace = graficate_3d([features_map[point][1]], [features_map[point][2]], [features_map[point][3]], colors[i], "Point $point", "markers")
            # push!(centroid_traces, trace)
            for j in 1:num_dimensions
                push!(dimension_points[j], features_map[point][j])
            end

        end
        trace = graficate_3d(dimension_points[1], dimension_points[2], dimension_points[3], colors[i], "Points in Centroid $i", "markers")
        push!(traces, trace)
    end

    l = Layout(title="Scatter Plot")
    display(plot([trace for trace in traces], l))

end


# function create_bigger_dots(img, coordinates, color, neighborhood_size=1)
#     m, n = size(img)
#     x, y = round.(Int, coordinates)
    
#     for i in max(1, x-neighborhood_size):min(m, x+neighborhood_size)
#         for j in max(1, y-neighborhood_size):min(n, y+neighborhood_size)
#             img[i, j] = color
#         end
#     end
# end