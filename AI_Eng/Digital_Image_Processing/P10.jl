# Constanst
IMAGE_URL = "fabio_gray_256" 

# libs
using TestImages, Images, ImageView, Plots

function message()
    println("==============================================")
    println("======= I m a g e   S m o o t h i n g ========")
    println("==============================================")
end

function loadImage()
    img = testimage(IMAGE_URL)
    img = Gray.(img)
    img = imresize(img, (256,256))
    return img
end

function saltAndPepperNoise(img)
    saltAndPepperImg = copy(img)
    n,m = size(img)
    println("Tell me the porcentage of noise you want to add")
    porcentage = parse(Int64, readline())
    total_pixels = n*m
    pixels_with_noise = round(Int64, total_pixels * (porcentage/100))
    
    for i in 1:pixels_with_noise
        x = rand(1:n)
        y = rand(1:m)
        if rand(1:2) == 1
            saltAndPepperImg[x,y] = N0f8(0)
        else
            saltAndPepperImg[x,y] = N0f8(1)
        end
    end
    return saltAndPepperImg
end

function smoothingImg(saltAndPepperImg) 
    # [x-1, y - 1]       [x, y - 1] [x + 1, y - 1]
    # [x - 1, y]     [x,y]      [x + 1, y]
    # [x - 1, y + 1][x, y + 1] [x + 1, y + 1]
    n,m = size(saltAndPepperImg)
    cleanImg = copy(saltAndPepperImg)
    for x in axes(cleanImg, 1)
        for y in axes(cleanImg, 2)
            arrayOfPixels = []
            for i in -1:1
                for j in -1:1
                    if x + i in axes(cleanImg, 1) && y + j in axes(cleanImg, 2)
                        push!(arrayOfPixels, saltAndPepperImg[x + i, y + j])
                    end
                end
            end
            arrayOfPixels = sort(arrayOfPixels)
            mid = round(Int64, length(arrayOfPixels)/2)
            cleanImg[x, y] = arrayOfPixels[mid]
        end
    end
    
    return cleanImg
end

function main()

    while true
        message()
        img = loadImage()
        display(img)
        # Mostrar la imagen en el Plot Pane
        # plot(img, aspect_ratio=:equal, axis=:off)
    
        saltAndPepperImg = saltAndPepperNoise(img)
        # plot(saltAndPepperImg, aspect_ratio=:equal, axis=:off)
        display(saltAndPepperImg)
        cleanImg = smoothingImg(saltAndPepperImg) 
        # plot(cleanImg, aspect_ratio=:equal, axis=:off)
        display(cleanImg) 


        println("\n########################################")
        println("Si deseas salir del programa ingresa 'q' o presiona cualquier tecla")
        op = readline()
        if op  == "q"
            break
        end
    end


end
