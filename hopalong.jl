using GLMakie, ColorSchemes
GLMakie.activate!()
Makie.inline!(true)

function hopalong(num, a, b, c)
    x, y = 0.0, 0.0  
    u = Vector{Float64}(undef, num)
    v = Vector{Float64}(undef, num)
    d = Vector{Float64}(undef, num)

    for i in 1:num
        u[i], v[i], d[i] = x, y, sqrt(x^2 + y^2)
        x, y = y - sign(x) * sqrt(abs(b * x - c)), a - x
    end

    fig = scatter(u, v, color=d, colormap="magma", markersize=0.000001, 
        figure=(size=(1000, 1000), fontsize=13),
        axis=(xlabel="x' = y-sign(x)*sqrt(abs(b*x-c))", 
              ylabel="y' = a-x",
              title="Orbit of 'Martins Map'. num=$num, a=$a, b=$b, c=$c")
    )

    save("Martins_Pics/hopalong_$num.png", fig)
    display(fig)
end   

hopalong(10_000_000, -2, -0.33, 0.01)