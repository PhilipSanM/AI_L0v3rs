# Segementation basics
# start date : 16 Octiber 2023

using Images, TestImages, ImageView

import Gtk4.open_dialog as dig

function main()
    path::String = dig("Pick a File"; start_folder = "C:/Users/MrJel/Desktop/Felix/Gitthis/AI_L0v3rs/AI_Eng/Artificial Vision/screw_db")
    
    img = load(path)

    img = Gray.(img)
    img = imresize(img, (256, 256))

    img_binary = zeros(size(img))

    threshold = 0.5  # Corrige el nombre de la variable


    for i in 1:size(img, 1)
        for j in 1:size(img, 2)
            pixel = img[i, j]
            if pixel > threshold
                img_binary[i, j] = 1
            else
                img_binary[i, j] = 0
            end
        end
    end

    num_objects = 0

    
    painted_image = load(path)
    painted_image = imresize(painted_image, (256, 256))
    color_objects_blue = RGB{N0f8}(0, 0, 1)


    for i in 1:size(img_binary, 1)
        for j in 1:size(img_binary, 2)
            if img_binary[i, j] == 1
                num_objects += 1
                dfs(img_binary, i, j, painted_image, color_objects_blue)
            end
        end
    end

    println("Number of objects: ", num_objects)
    display(painted_image)

    # print("Sizez of the image: ", size(img_binary, 1), " ", size(img_binary, 2))
    # print("sizes of the new img ", size(painted_image, 1), " ", size(painted_image, 2))


    

    

    # Aquí puedes realizar alguna operación adicional con la imagen binarizada si lo deseas.
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







