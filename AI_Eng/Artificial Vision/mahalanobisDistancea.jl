using TestImages, Images, FixedPointNumbers, Plots, StatsBase

# Plotting a 3d cube with FixedPointNumbers
    # [x, y, z]
class1 = [0 0 0; 1 0 0; 1 0 1; 1 1 0]
class2 = [0 0 1; 0 1 1; 1 1 1; 0 1 0]

function readCoordinates()
    println("Tell me the coordinates of the point to classify")
    println("X: ")
    x = parse(Float64, readline())
    println("Y: ")
    y = parse(Float64, readline())
    println("Z: ")
    z = parse(Float64, readline())

    point = [x; y; z]
    return point
end

function plotCube(point, classColor)
    # Plotting
    x_class1 = class1[:,1]
    y_class1 = class1[:,2]
    z_class1 = class1[:,3]

    x_class2 = class2[:,1]
    y_class2 = class2[:,2]
    z_class2 = class2[:,3]

    # Plotea los puntos de cada clase con colores diferentes
    scatter3d(x_class1, y_class1, z_class1, color = :blue, label = "Class 1")
    scatter3d!(x_class2, y_class2, z_class2, color = :red, label = "Class 2")
    scatter3d!([point[1]], [point[2]], [point[3]], color = classColor, label = "Point to classify")

    # Configura el aspecto del gráfico
    xlabel!("X")
    ylabel!("Y")
    zlabel!("Z")
        
end

function getMu(class1)
    mu = Float64[0; 0; 0]
    for i in 1:3
        mu[i] = mean(class1[:,i])
    end
    return mu
end


function  getSigma(class, mu)
    sigma = zeros((3,3))
    mu = getMu(class1)
    
    matrix = class1' .- mu

    matrix = matrix*matrix'
    
    sigma = (1/4)*matrix
    return sigma
end

function getMahalanobisDistance(class1,point)
    distance = [0]
    mu = getMu(class1)

    sigma = getSigma(class1, mu)

    distance = (point - mu)' * inv(sigma) * (point - mu)

    return distance
end

function main()
    println("==============================================")
    println("======= Mahalanobis Distance =================")
    println("==============================================")
    point = readCoordinates()
    # point = Float64[0.5 ; 0.5 ; 0.5]
    distance1 = getMahalanobisDistance(class1, point)
    distance2 = getMahalanobisDistance(class2, point)
    println("Distance to class 1: ", distance1)
    println("Distance to class 2: ", distance2)

    if distance1 < distance2
        println("The point belongs to class 1")
        plotCube(point, :blue)
    else
        println("The point belongs to class 2")
        plotCube(point, :red)
    end
    
end