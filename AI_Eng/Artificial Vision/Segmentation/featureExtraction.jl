using Images, ImageView
import Gtk4.open_dialog as dig



function main()
    path::String = dig("Pick a File"; start_folder = "C:/Users/MrJel/Desktop/Felix/Gitthis/AI_L0v3rs/AI_Eng/Artificial Vision/screw_db")
    
    img = load(path)
    img = imresize(img, (256, 256))

    painted_image = copy(img)
    img = Gray.(img)
    img_binary = zeros(size(img))
    m,n= size(img)

    threshold = 0.5 

    for i in eachindex(img)
        pixel = img[i]
        if pixel > threshold
            img_binary[i] = 1
        else
            img_binary[i] = 0
        end
    end

    num_objects = 0

    for i in 1:m
        for j in 1:n
            if img_binary[i, j] == 1
                num_objects += 1
                dfs(img_binary, i, j, painted_image, RGB(rand(3)...))
            end
        end
    end

    println("Number of objects: ", num_objects)
    display(painted_image)

    println("Sizez of the image: ", size(img_binary, 1), " ", size(img_binary, 2))
    println("sizes of the new img ", size(painted_image, 1), " ", size(painted_image, 2))


    # Feature Extraction:
    img_binary = makeImage2Binary(img)

    perimeters = extractPerimeters(img_binary)

    println("Perimeters: ", perimeters)

    areas = extractArea(img_binary)

    println("Areas: ", areas)




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


    m,n = size(img)

    perimeters = []
    visited =  []

    for i in 1:m
        for j in 1:n
            if img[i, j] == 1 && (i, j) ∉ visited
                perimeter = dfsPerimeter(img, i, j, visited)
                push!(perimeters, perimeter)
            end
        end
    end

    # Only values non cero
    perimeters = filter(x -> x != 0, perimeters)
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

    for i in 1:m
        for j in 1:n
            if img[i, j] == 1 && (i, j) ∉ visited
                area = dfsValues(img, i, j, visited)
                push!(total_areas, area)
            end
        end
    end

    areas = total_areas ./ totalPixels

    return areas
end



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