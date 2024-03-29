#     INSTITUTO POLITÉCNICO NACIONAL
#     ESCUELA SUPERIOR DE COMPUTO
#     VISION ARTIFICIAL
#     PRACTICA 1 - IDENTIFICACION DE OBJETOS

using Images, ImageView, Plots
import Gtk4.open_dialog as dig

function dfs_4(matrix, i, j, painted_image, color_objects)
    if i < 1 || i >= size(matrix, 1) || j < 1 || j >= size(matrix, 2)
        return
    end

    if matrix[i, j] == 0
        return
    end

    matrix[i, j] = 0
    painted_image[i, j] = color_objects

    dfs_4(matrix, i + 1, j, painted_image, color_objects)
    dfs_4(matrix, i - 1, j, painted_image, color_objects)
    dfs_4(matrix, i, j + 1, painted_image, color_objects)
    dfs_4(matrix, i, j - 1, painted_image, color_objects)



end


function dfs_8(matrix, i, j, painted_image, color_objects)
    if i < 1 || i >= size(matrix, 1) || j < 1 || j >= size(matrix, 2)
        return
    end

    if matrix[i, j] == 0
        return
    end

    matrix[i, j] = 0
    painted_image[i, j] = color_objects

    dfs_8(matrix, i + 1, j, painted_image, color_objects)
    dfs_8(matrix, i - 1, j, painted_image, color_objects)
    dfs_8(matrix, i, j + 1, painted_image, color_objects)
    dfs_8(matrix, i, j - 1, painted_image, color_objects)

    # diagonalls
    dfs_8(matrix, i + 1, j + 1, painted_image, color_objects)
    dfs_8(matrix, i - 1, j + 1, painted_image, color_objects)
    dfs_8(matrix, i + 1, j - 1, painted_image, color_objects)
    dfs_8(matrix, i - 1, j - 1, painted_image, color_objects)

end


function main_4(path)
    # path::String = dig("Pick a File"; start_folder = "C:/Users/diego/OneDrive/Escritorio/ESCOM/5SEM/VA/Parcial2/bd")
    
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
                dfs_4(img_binary, i, j, painted_image, RGB(rand(3)...))
            end
        end
    end

    println("Number of objects: ", num_objects)
    display(painted_image)

    print("Sizez of the image: ", size(img_binary, 1), " ", size(img_binary, 2))
    print("sizes of the new img ", size(painted_image, 1), " ", size(painted_image, 2))
end


img = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
       0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0;
       0 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1 0 0;
       0 1 1 1 1 1 1 1 1 0 0 0 1 1 1 1 0 0;
       0 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 0 0;
       0 1 1 1 1 1 0 0 0 0 0 1 1 1 1 1 0 0;
       0 0 1 1 1 0 0 0 0 0 0 1 1 1 1 1 1 0;
       0 0 0 1 1 0 0 0 0 0 0 0 0 1 1 1 0 0;
       0 0 0 1 0 0 0 0 0 0 0 0 0 0 1 1 0 0;

]


function main_8(path)
    # path::String = dig("Pick a File"; start_folder = "C:/Users/diego/OneDrive/Escritorio/ESCOM/5SEM/VA/Parcial2/bd")
    
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
                dfs_8(img_binary, i, j, painted_image, RGB(rand(3)...))
            end
        end
    end

    println("Number of objects: ", num_objects)
    display(painted_image)

    print("Sizez of the image: ", size(img_binary, 1), " ", size(img_binary, 2))
    print("sizes of the new img ", size(painted_image, 1), " ", size(painted_image, 2))
end

function main()

    
    img = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1 0 0;
    0 1 1 1 1 1 1 1 1 0 0 0 1 1 1 1 0 0;
    0 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 0 0;
    0 1 1 1 1 1 0 0 0 0 0 1 1 1 1 1 0 0;
    0 0 1 1 1 0 0 0 0 0 0 1 1 1 1 1 1 0;
    0 0 0 1 1 0 0 0 0 0 0 0 0 1 1 1 0 0;
    0 0 0 1 0 0 0 0 0 0 0 0 0 0 1 1 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0

    ]

    plot = heatmap(img, color=:grays, aspect_ratio=:equal, yflip=true, legend=false, axis=false, grid=false, ticks=false, border=:none)
    display(plot)
    path = "./Examen.png"
    savefig(plot, path)

    print("Imagen de 4 conexiones")
    main_4(path)

    print("Imagen de 8 conexiones")
    main_8(path)
end