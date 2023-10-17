# Segementation basics
# start date : 16 Octiber 2023

using Images, TestImages

function main()
    img = testimage("fabio_color_256.png")
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

    for i in 1:size(img_binary, 1)
        for j in 1:size(img_binary, 2)
            if img_binary[i, j] == 1
                num_objects += 1
                dfs(img_binary, i, j)
            end
        end
    end

    println("Number of objects: ", num_objects)




    

    

    # Aquí puedes realizar alguna operación adicional con la imagen binarizada si lo deseas.
end

function dfs(matrix, i, j)
    if i < 1 || i >= size(matrix, 1) || j < 1 || j >= size(matrix, 2)
        return
    end

    if matrix[i, j] == 0
        return
    end

    matrix[i, j] = 0

    dfs(matrix, i + 1, j)
    dfs(matrix, i - 1, j)
    dfs(matrix, i, j + 1)
    dfs(matrix, i, j - 1)

    # diagonalls
    dfs(matrix, i + 1, j + 1)
    dfs(matrix, i - 1, j + 1)
    dfs(matrix, i + 1, j - 1)
    dfs(matrix, i - 1, j - 1)

end







