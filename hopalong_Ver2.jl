using Plots
using Statistics: extrema

function compute_extents(a, b, c, n)
    x, y = 0.0, 0.0
    min_x, max_x = Inf, -Inf
    min_y, max_y = Inf, -Inf

    for _ in 1:n
        min_x = min(x, min_x)
        max_x = max(x, max_x)
        min_y = min(y, min_y)
        max_y = max(y, max_y)
        x, y = y - copysign(1.0, x) * sqrt(abs(b * x - c)), a - x
    end
    return (min_x, max_x, min_y, max_y)
end                                                                                        

function compute_image(a, b, c, n, extents, image_size)
    min_x, max_x, min_y, max_y = extents
    scale_x = (image_size[2] - 1) / (max_x - min_x)
    scale_y = (image_size[1] - 1) / (max_y - min_y)
    image = zeros(UInt64, image_size...)
    
    x, y = 0.0, 0.0
    for _ in 1:n
        px = round(Int, (x - min_x) * scale_x) + 1  # Julia is 1-indexed
        py = round(Int, (y - min_y) * scale_y) + 1
        
        if 1 <= px <= image_size[2] && 1 <= py <= image_size[1]
            image[py, px] += 1
        end
        x, y = y - copysign(1.0, x) * sqrt(abs(b * x - c)), a - x
    end
    return image
end

function main()
    # Hardcoded parameters
    a, b, c = -0.6, 0.5, 0
    n = 10000000  # No formatting needed
    image_size = (1000, 1000)
    color_map = :hot

    # Compute extents and image
    extents = compute_extents(a, b, c, n)
    image = compute_image(a, b, c, n, extents, image_size)

    # Plot (using raw number in title)
    heatmap(image, 
           aspect_ratio=1,
           color=color_map,
           clims=extrema(image),
           title="Hopalong Attractor (Julia)\na=$a, b=$b, c=$c, n=$n",
           xlabel="X", ylabel="Y",
           size=(800, 800)) |> display
           sleep(10)  # Shows plot for 10 seconds
    
    savefig("hopalong_julia.png")
end

main()
