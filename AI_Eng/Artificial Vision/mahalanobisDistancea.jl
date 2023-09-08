using TestImages, Images, FixedPointNumbers, Plots, StatsBase

# Plotting a 3d cube with FixedPointNumbers

function readCoordinates()
    println("Tell me the coordinates of the point to classify")
    println("X: ")
    x = parse(Float64, readline())
    println("Y: ")
    y = parse(Float64, readline())
    println("Z: ")
    z = parse(Float64, readline())

    point = [x, y, z]
    return point
end

function plotCube(point, classColor)
    # [x, y, z]
    class1 = [[0,0,0], [1, 0, 0], [1, 1, 0], [1, 0, 1]]
    class2 = [[0,0,1], [1, 1, 1], [0, 1, 1], [0, 1, 0]]

    # Plotting

    # Separa las coordenadas x, y, y z de cada clase
    x_class1 = [v[1] for v in class1]
    y_class1 = [v[2] for v in class1]
    z_class1 = [v[3] for v in class1]

    x_class2 = [v[1] for v in class2]
    y_class2 = [v[2] for v in class2]
    z_class2 = [v[3] for v in class2]

    # Plotea los puntos de cada clase con colores diferentes
    scatter3d(x_class1, y_class1, z_class1, color = :blue, label = "Class 1")
    scatter3d!(x_class2, y_class2, z_class2, color = :red, label = "Class 2")
    scatter3d!([point[1]], [point[2]], [point[3]], color = classColor, label = "Point to classify")

    # Configura el aspecto del gráfico
    xlabel!("X")
    ylabel!("Y")
    zlabel!("Z")
        
end

function getMahalanobisDistance(class1,point)
    distance = [0]
    
    

    return distance
end

function main()
    println("==============================================")
    println("======= Mahalanobis Distance =================")
    println("==============================================")
    point = readCoordinates()






    
end