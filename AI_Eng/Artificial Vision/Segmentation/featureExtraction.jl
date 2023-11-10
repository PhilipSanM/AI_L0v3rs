using Images, ImageView
import Gtk4.open_dialog as dig
using ImageIO

using Statistics
using PlotlyJS


function main()


    # Screw Paths
    screwsPath = "C:/Users/MrJel/Desktop/Felix/Gitthis/AI_L0v3rs/AI_Eng/Artificial Vision/screw_db/Screws_only/"
    
    rondanaPath = "C:/Users/MrJel/Desktop/Felix/Gitthis/AI_L0v3rs/AI_Eng/Artificial Vision/screw_db/Rondanas_only/"

    alemPath = "C:/Users/MrJel/Desktop/Felix/Gitthis/AI_L0v3rs/AI_Eng/Artificial Vision/screw_db/Alem_only/"

    idkPath = "C:/Users/MrJel/Desktop/Felix/Gitthis/AI_L0v3rs/AI_Eng/Artificial Vision/screw_db/Idk_only/"

    # Features
    print("======= FEATURES ========\n")

    screwsFeatures = getFeaturesFromImges(screwsPath)
    rondanaFeatures = getFeaturesFromImges(rondanaPath)
    alemFeatures = getFeaturesFromImges(alemPath)
    idkFeatures = getFeaturesFromImges(idkPath)

    println("Screws Features: ", screwsFeatures)
    println("Rondana Features: ", rondanaFeatures)
    println("Alem Features: ", alemFeatures)
    println("Idk Features: ", idkFeatures)
    

    # Test

    while true
        print("\n======= TEST WITH YOUr IMAGE ========\n")
        path::String = dig("Pick a File"; start_folder = "C:/Users/MrJel/Desktop/Felix/Gitthis/AI_L0v3rs/AI_Eng/Artificial Vision/screw_db/All")

        img = load(path)
        img = imresize(img, (256, 256))
        img = Gray.(img)

        perimeters, areas, points = getFeatureExtraction(path)

        feature2know = hcat(perimeters, areas)'

        totalScrews = 0
        totaRondanas = 0
        totalIdk = 0
        totalAlem = 0

        println("Features: ", feature2know)

        # Plot:
        trace1 = scatter(y=screwsFeatures[1,:], x=screwsFeatures[2,:], name="Screws", mode="markers", color ="red")
        trace2 = scatter(y=rondanaFeatures[1,:], x=rondanaFeatures[2,:], name="Rondanas", mode="markers", color = :blue)
        trace3 = scatter(y=alemFeatures[1,:], x=alemFeatures[2,:], name="Alem", mode="markers", color = :green)
        trace4 = scatter(y=idkFeatures[1,:], x=idkFeatures[2,:], name="Idk", mode="markers", color = :yellow)
        
        trace5 = scatter(y=feature2know[1,:], x=feature2know[2,:], name="Unknown", mode="markers", color = :black)

        display(plot([trace1, trace2, trace3, trace4, trace5]))


        # K-NN   
        k = 3
        println("Points coordinates= ", points)

        classes = Dict("Screws" => screwsFeatures, "Rondanas" => rondanaFeatures, "Alem" => alemFeatures, "Idk" => idkFeatures)
        
        paintedImage = copy(img)
        idx = 0
        for point in eachcol(feature2know)
            predicted_class = predict_using_knn(k, classes, point)
            if predicted_class == "Screws"
                totalScrews += 1
                paintObjects(makeImage2Binary(img), paintedImage, RGB(1, 0, 0), points[idx + 1])
            elseif predicted_class == "Rondanas"
                totaRondanas += 1
                paintObjects(makeImage2Binary(img), paintedImage, RGB(0, 0, 1), points[idx + 1])
            elseif predicted_class == "Alem"
                totalAlem += 1
                paintObjects(makeImage2Binary(img), paintedImage, RGB(0, 1, 0), points[idx + 1])
            else
                totalIdk += 1
                paintObjects(makeImage2Binary(img), paintedImage, RGB(1, 1, 0), points[idx + 1])
            end
        end

        display(paintedImage)






        num_object = getNumberOfObjects(makeImage2Binary(img), path)


        println("Screws: ", totalScrews)
        println("Rondanas: ", totaRondanas)
        println("Alem: ", totalAlem)
        println("Idk: ", totalIdk)

        

        println("\n\nSi deseas salir del programas ingresa 'q' ");
        input = readline(stdin);
        if input == "q"
            break
        end  
    end

end

function getFeaturesFromImges(path)
    # Screw Data
    folder = readdir(path)
    folder = [path * gg for gg in folder]

    perimeters = []
    areas = []

    for img in folder
        perimeter, area, dummy = getFeatureExtraction(img)
        for aux in perimeter
            push!(perimeters, aux)
        end
        for aux in area
            push!(areas, aux)
        end
    end


    # Matrix with perimeters and areas 2-d
    if length(perimeters) != length(areas)
        println("Error")
        println("Perimeters: ", perimeters)
        println("Areas: ", areas)
        return [1 2; 3 4]
    end

    features = hcat(perimeters, areas)

    return features'

end

function getFeatureExtraction(path)
    
    # Img
    img = load(path)
    img = imresize(img, (256, 256))
    img = Gray.(img)
    img_binary = makeImage2Binary(img)

    # # Number of objects
    # num_objects = getNumberOfObjects(copy(img_binary), path)

    # Feature Extraction:

    perimeters = extractPerimeters(img_binary)

    areas, points = extractArea(img_binary)

    return perimeters, areas, points
    
end


function makeImage2Binary(img)

    img = Gray.(img)
    img_binary = zeros(size(img))
    threshold = 0.5 

    for i in eachindex(img)
        pixel = img[i]
        if pixel > threshold
            img_binary[i] = 1
        else
            img_binary[i] = 0
        end
    end

    return img_binary
end


function extractPerimeters(img)

    function dfsPerimeter(matrix, i, j, visited)
        if i < 1 || i >= size(matrix, 1) || j < 1 || j >= size(matrix, 2)
            return 0
        end
        if matrix[i, j] == 0 || (i, j) ∈ visited
            return 0
        end
        push!(visited, (i, j))
        if (matrix[i + 1, j] == 0 || matrix[i - 1, j] == 0 || matrix[i, j + 1] == 0 || matrix[i, j - 1] == 0 || matrix[i + 1, j + 1] == 0 || matrix[i - 1, j + 1] == 0 || matrix[i + 1, j - 1] == 0 || matrix[i - 1, j - 1] == 0) 

            return 1 + dfsPerimeter(matrix, i + 1, j, visited) + dfsPerimeter(matrix, i - 1, j, visited) + dfsPerimeter(matrix, i, j + 1, visited) + dfsPerimeter(matrix, i, j - 1, visited) + dfsPerimeter(matrix, i + 1, j + 1, visited) + dfsPerimeter(matrix, i - 1, j + 1, visited) + dfsPerimeter(matrix, i + 1, j - 1, visited) + dfsPerimeter(matrix, i - 1, j - 1, visited)
        end
        return 0
        
    end

    function dfsForAddingFullBody(matrix, i, j, visited)
        if i < 1 || i >= size(matrix, 1) || j < 1 || j >= size(matrix, 2)
            return 
        end

        if matrix[i, j] == 0 || (i, j) ∈ visited
            return 
        end

        push!(visited, (i, j))

        dfsForAddingFullBody(matrix, i + 1, j, visited)
        dfsForAddingFullBody(matrix, i - 1, j, visited)
        dfsForAddingFullBody(matrix, i, j + 1, visited)
        dfsForAddingFullBody(matrix, i, j - 1, visited)
    
        # diagonalls
        dfsForAddingFullBody(matrix, i + 1, j + 1, visited)
        dfsForAddingFullBody(matrix, i - 1, j + 1, visited)
        dfsForAddingFullBody(matrix, i + 1, j - 1, visited)
        dfsForAddingFullBody(matrix, i - 1, j - 1, visited)
        
    end

    m,n = size(img)

    perimeters = []
    visited =  []

    for i in 1:m
        for j in 1:n
            if img[i, j] == 1 && (i, j) ∉ visited
                perimeter = dfsPerimeter(img, i, j, visited)
                push!(perimeters, perimeter)

                dfsForAddingFullBody(img, i + 1, j, visited)
                dfsForAddingFullBody(img, i - 1, j, visited)
                dfsForAddingFullBody(img, i, j + 1, visited)
                dfsForAddingFullBody(img, i, j - 1, visited)
            
                # diagonalls
                dfsForAddingFullBody(img, i + 1, j + 1, visited)
                dfsForAddingFullBody(img, i - 1, j + 1, visited)
                dfsForAddingFullBody(img, i + 1, j - 1, visited)
                dfsForAddingFullBody(img, i - 1, j - 1, visited)
            end
        end
    end

    # Only values non cero
    perimeters = [x for x in perimeters if x != 0]

    return perimeters

end


function extractArea(img)
    function dfsSize(matrix, i, j, visited)
        if i < 1 || i >= size(matrix, 1) || j < 1 || j >= size(matrix, 2)
            return 0
        end
        if matrix[i, j] == 0 || (i, j) ∈ visited
            return 0
        end
        push!(visited, (i, j))

        return matrix[i, j] + dfsSize(matrix, i + 1, j, visited) + dfsSize(matrix, i - 1, j, visited) + dfsSize(matrix, i, j + 1, visited) + dfsSize(matrix, i, j - 1, visited) + dfsSize(matrix, i + 1, j + 1, visited) + dfsSize(matrix, i - 1, j + 1, visited) + dfsSize(matrix, i + 1, j - 1, visited) + dfsSize(matrix, i - 1, j - 1, visited)
    end

    function dfsValues(matrix, i, j, visited)
        if i < 1 || i >= size(matrix, 1) || j < 1 || j >= size(matrix, 2)
            return 0
        end
        if matrix[i, j] == 0 || (i, j) ∈ visited
            return 0
        end
        push!(visited, (i, j))

        return i * matrix[i, j] + dfsSize(matrix, i + 1, j, visited) + dfsSize(matrix, i - 1, j, visited) + dfsSize(matrix, i, j + 1, visited) + dfsSize(matrix, i, j - 1, visited) + dfsSize(matrix, i + 1, j + 1, visited) + dfsSize(matrix, i - 1, j + 1, visited) + dfsSize(matrix, i + 1, j - 1, visited) + dfsSize(matrix, i - 1, j - 1, visited)
       
        
    end


    m,n = size(img)

    areas = []
    visited =  []
    totalPixels = []

    for i in 1:m
        for j in 1:n
            if img[i, j] == 1 && (i, j) ∉ visited
                total = dfsSize(img, i, j, visited)
                push!(totalPixels, total)
            end
        end
    end

    visited =  []
    total_areas = []

    points = []

    for i in 1:m
        for j in 1:n
            if img[i, j] == 1 && (i, j) ∉ visited
                area = dfsValues(img, i, j, visited)
                push!(total_areas, area)
                push!(points, (i, j))
            end
        end
    end

    areas = total_areas ./ totalPixels

    return areas, points
end





function getNumberOfObjects(img_binary, path)
    painted_image = load(path)
    painted_image = imresize(painted_image, (256, 256))
    function dfs(matrix, i, j, painted_image, color_objects)
        if i < 1 || i >= size(matrix, 1) || j < 1 || j >= size(matrix, 2)
            return
        end
    
        if matrix[i, j] == 0
            return
        end
    
        matrix[i, j] = 0
        painted_image[i, j] = color_objects
    
        dfs(matrix, i + 1, j, painted_image, color_objects)
        dfs(matrix, i - 1, j, painted_image, color_objects)
        dfs(matrix, i, j + 1, painted_image, color_objects)
        dfs(matrix, i, j - 1, painted_image, color_objects)
    
        # diagonalls
        dfs(matrix, i + 1, j + 1, painted_image, color_objects)
        dfs(matrix, i - 1, j + 1, painted_image, color_objects)
        dfs(matrix, i + 1, j - 1, painted_image, color_objects)
        dfs(matrix, i - 1, j - 1, painted_image, color_objects)
    
    end

    img = load(path)
    img = imresize(img, (256, 256))


    m,n = size(img_binary)


    num_objects = 0

    for i in 1:m
        for j in 1:n
            if img_binary[i, j] == 1
                num_objects += 1
                dfs(img_binary, i, j, painted_image, RGB(rand(3)...))
            end
        end
    end

    
    # display(painted_image)

    return num_objects

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



# KNN

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

    votes = Dict("Screws" => 0, "Rondanas" => 0, "Alem" => 0, "Idk" => 0)

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

get_eucledian_distance(pointA, pointB) = sqrt(sum((pointA .- pointB).^2))




function paintObjects(img_binary, painted_image, color, point)
    function dfs(matrix, i, j, painted_image, color_objects)
        if i < 1 || i >= size(matrix, 1) || j < 1 || j >= size(matrix, 2)
            return
        end
    
        if matrix[i, j] == 0
            return
        end
    
        matrix[i, j] = 0
        painted_image[i, j] = color_objects
    
        dfs(matrix, i + 1, j, painted_image, color_objects)
        dfs(matrix, i - 1, j, painted_image, color_objects)
        dfs(matrix, i, j + 1, painted_image, color_objects)
        dfs(matrix, i, j - 1, painted_image, color_objects)
    
        # diagonalls
        dfs(matrix, i + 1, j + 1, painted_image, color_objects)
        dfs(matrix, i - 1, j + 1, painted_image, color_objects)
        dfs(matrix, i + 1, j - 1, painted_image, color_objects)
        dfs(matrix, i - 1, j - 1, painted_image, color_objects)
    
    end

    dfs(img_binary, point[1], point[2], painted_image, color)
    

end

