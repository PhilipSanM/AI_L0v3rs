# Constanst
IMAGE_URL = "fabio" 

# libs
using TestImages, Images, FixedPointNumbers, Plots, StatsBase

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
    n, m = size(img)
    println("Tell me the percentage of noise you want to add")
    percentage = parse(Int64, readline())
    total_pixels = n * m
    pixels_with_noise = round(Int64, total_pixels * (percentage / 100))
    
    localizations = Dict{Tuple{Int, Int}, Bool}()
    
    for i in 1:pixels_with_noise
        x = rand(1:n)
        y = rand(1:m)
        while (x, y) in keys(localizations)
            x = rand(1:n)
            y = rand(1:m)
        end
        localizations[(x, y)] = true
        
        if rand(1:2) == 1
            saltAndPepperImg[x, y] = N0f8(0)
        else
            saltAndPepperImg[x, y] = N0f8(1)
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
            # Skipping saltAndPepperImg pixels
            if saltAndPepperImg[x, y] == N0f8(0) || saltAndPepperImg[x, y] == N0f8(1)
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
    end
    
    return cleanImg
end

function obtainMode(arrayOfPixels)
    modes = Dict{N0f8, Int}()
    for i in eachindex(arrayOfPixels)
        if arrayOfPixels[i] in keys(modes)
            modes[arrayOfPixels[i]] += 1
        else
            modes[arrayOfPixels[i]] = 1
        end
    end
    max = -1
    mode = arrayOfPixels[1]

    for i in keys(modes)
        if modes[i] > max
            max = modes[i]
            mode = i
        end
    end
    # println("max: ", max)
    # println("mode: ", mode)
    # println("==============================================")

    if max == 1 # Case 1
        # println("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
        # Defining limits 
        # group_limits = [0.0N0f8, 0.1N0f8, 0.2N0f8, 0.3N0f8, 0.4N0f8, 0.5N0f8, 0.6N0f8, 0.7N0f8, 0.8N0f8, 0.9N0f8, 1.0N0f8]
        group_limits = [0.0N0f8, 0.2N0f8, 0.4N0f8,  0.6N0f8,  0.8N0f8,  1.0N0f8]



        # Initializing dictionary for group modes
        modesOfGroups = Dict{N0f8, Int}()

        # Iterating over the pixel array
        for i in eachindex(arrayOfPixels)
            pixel = arrayOfPixels[i]
            group_limit = 0.0N0f8

            # Finding the corresponding group for the pixel
            for j in eachindex(group_limits)
                if pixel >= group_limits[j] && pixel <= group_limits[j+1]
                    group_limit = group_limits[j]
                    break
                end
            end
            # adding the +1 to the group
            if group_limit in keys(modesOfGroups)
                modesOfGroups[group_limit] += 1
            else
                modesOfGroups[group_limit] = 1
            end

        end

        # Finding the max value betwen the groups
        max = -1
        limit = 0.0N0f8
        for key in keys(modesOfGroups)
            if modesOfGroups[key] > max
                max = modesOfGroups[key]
                limit = key
            end
        end
        # print("limit: ", limit)
        # println("max: ", max)

        # Finding the mode that fits in the limit
        for i in eachindex(arrayOfPixels)
            if arrayOfPixels[i] >= limit && arrayOfPixels[i] <= limit + 0.1N0f8
                # println("mode: ", arrayOfPixels[i])
                mode = arrayOfPixels[i]
                break
            end
        end
        # println("limit: ", limit)
        # println("max: ", max)
        # println("mode: ", mode)
        # println("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
    end

    return mode
end

function modeSmoothingImg(saltAndPepperImg) 
    # [x-1, y - 1]       [x, y - 1] [x + 1, y - 1]
    # [x - 1, y]     [x,y]      [x + 1, y]
    # [x - 1, y + 1][x, y + 1] [x + 1, y + 1]
    n,m = size(saltAndPepperImg)
    cleanImg = copy(saltAndPepperImg)
    for x in axes(cleanImg, 1)
        for y in axes(cleanImg, 2)
            # Skipping the salt and pepper pixels
            if saltAndPepperImg[x, y] == 0.0N0f8 || saltAndPepperImg[x, y] == 1.0N0f8
                arrayOfPixels = []
                for i in -1:1
                    for j in -1:1
                        if x + i in axes(cleanImg, 1) && y + j in axes(cleanImg, 2)
                            push!(arrayOfPixels, saltAndPepperImg[x + i, y + j])
                        end
                    end
                end
                
                arrayOfPixels = sort(arrayOfPixels)
                # moda = obtainMode(arrayOfPixels)
                moda = mode(arrayOfPixels)
                cleanImg[x, y] = moda
            end
        
        end
    end
    
    return cleanImg
end



function main()

    while true
        message()
        img = loadImage()
        # display(img)
        # Mostrar la imagen en el Plot Pane
        # plot(img, aspect_ratio=:equal, axis=:off)
    
        saltAndPepperImg = saltAndPepperNoise(img)
        # plot(saltAndPepperImg, aspect_ratio=:equal, axis=:off)
        # display(saltAndPepperImg)
        cleanImg = smoothingImg(saltAndPepperImg) 
        # plot(cleanImg, aspect_ratio=:equal, axis=:off)
        # display(cleanImg)
        for i in 1:2
            cleanImg = smoothingImg(cleanImg) 
        end 

        modeCleanImg = modeSmoothingImg(saltAndPepperImg)

        for i in 1:4
            modeCleanImg = modeSmoothingImg(modeCleanImg)
        end 

        # dis = mosaicview(img,saltAndPepperImg,cleanImg)
        # display(dis)

        p1 = plot(img, title= "original")
        p2 = plot(saltAndPepperImg, title= "salt and pepper")
        p3 = plot(cleanImg, title= "clean")
        p4 = plot(modeCleanImg, title= "mode clean")
        k = plot(p1, p2, p3, p4)
        display(k)


        println("\n########################################")
        println("Si deseas salir del programa ingresa 'q' o presiona cualquier tecla")
        op = readline()
        if op  == "q"
            break
        end
    end


end