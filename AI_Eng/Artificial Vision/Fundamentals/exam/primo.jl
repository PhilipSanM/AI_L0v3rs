using Primes, PlotlyJS, Statistics, LinearAlgebra


function main()
    println("Enter range: min max")
    punto = readline()
    p_cords = parse.(Int64, split(punto, " ", limit=2))'
    
    min = p_cords[1]
    top = p_cords[2]
    ppp= [i for i in min:top]

    primos = []
    noprimos = []
    for i in ppp
        if isprime(i)
            push!(primos, i)
        else
            push!(noprimos, i)
        end
    end 

    xprimo = [0 for i in primos]
    xnoprimo = [0 for i in noprimos]

    trace1 = scatter(y=xprimo, x=primos, name="primos", mode="markers")
    trace2 = scatter(y=xnoprimo, x=noprimos, name=" NO primos", mode="markers")

    while true
        println("Enter num")
        num = parse.(Int64, readline())

        if (num>=min) && (num<=top)
            if isprime(num)
                println("PERTENECE A CLASE 1 - ES PRIMO")
            else
                println("PERTENECE A CLASE 2 - NO ES PRIMO")
            end

            trace3 = scatter(x=0,y=[num], name="unknown", mode="markers")
            display(plot([trace1, trace2, trace3]))
        else
            println("El punto seleccionado  NO PERETENCE A NINGUNA CLASE")
        end

        println("\n\nSi deseas salir del programas ingresa 'q' ");
        input = readline(stdin);
        if input == "q"
            break
        end  
    end


end