module Geometry
import Base.==
export Point2D, Point3D, Polygon, distance, distance2, perimeter, isRectangular, area

"""
Point2D(x::Real, y::Real)
Create a point with an x coordinate and a y coordinate. A point will be returned as '(x,y)'.
Next, takes a point in the form of a string, returns in the form, '(x,y)'.
"""
struct Point2D
    x::Real
    y::Real

    function Point2D(x::Real, y::Real)
        new(x, y)
    end

    function Point2D(str::String)
        m = match(r"^\(\s*([+-]?\d*\.?\d+)\s*,\s*([+-]?\d*\.?\d+)\s*\)$", str)
        m === nothing && throw(ArgumentError("No argument is an integer or decimal."))
        x = occursin(r"\.",m[1]) ? parse(Float64, m[1]) : parse(Int64,m[1])
        y = occursin(r"\.",m[2]) ? parse(Float64, m[2]) : parse(Int64,m[2])
        Point2D(x,y)
    end

end


Base.show(io::IO,p::Point2D) = print(io, string("(",(p.x),", ",(p.y), ")"))

"""
Point3D(x::Real,y::real,z::Real)
Creates a 3-dimensional point with x coordinates, y coordinates, and z coordinates.
"""
struct Point3D
    x::Real
    y::Real
    z::Real
end

"""
Base.show(io::IO,d::Point3D)
Takes a Point3D object and returns just the x,y,and z coordinates.
"""
Base.show(io::IO,d::Point3D) = print(io,string("(",(d.x),",",(d.y),",",(d.z),")"))

"""
    Polygon(pts::Vector{Point2d})
    Polygon(crds::Vector{<:Real})
    Polygon(reals::Vararg{<:Real})
Creates a polygon object with a vector of Point2D objects. The length of the points must satisfy 'length(pts) >= 3' or it will throw an argument.
In addition, one can make a polygon with a vector of reals, where the length of the vector must be 'mod(n,2) == 0' and must satisfy 'n>=6' or it will throw an argument.
Lastly, one can make a polygon with a Vararg, or a list of reals. The list of reals are put through the tests for the second constructor and then turned into a vector
of points.
"""
struct Polygon
    pts::Vector{Point2D}

    function Polygon(pts::Vector{Point2D})
        length(pts) >= 3 || throw(ArgumentError("There needs to be at least 3 points"))
        new(pts)
    end

    function Polygon(crds::Vector{<:Real})
        local n = length(crds)
        mod(n,2) == 0 || throw(ArgumentError("The number of coordinates must be even in order for each point to have an X and Y"))
        n>=6 || throw(ArgumentError("There should be at least three X coordinates and three Y coordinates in order to be a Polygon."))
        points = [Point2D(crds[i], crds[i+1]) for i in 1:2:n]
        new(points)
    end

    function Polygon(reals::Vararg{<:Real})
        crds = collect(reals)
        return Polygon(crds)
    end
end

"""
===(p1::Point2D,p2::Point2d)
Returns boolean if both two-dimensional points are equal.
"""
function ==(p1::Point2D,p2::Point2D)
    p1.x == p2.x && p1.y == p2.y
end

"""
===((p1::Point3D,p2::Point3D)
Returns a boolean if both three-dimensional points are equal.
"""
function ==(p1::Point3D,p2::Point3D)
    p1.x == p2.x && p1.y == p2.y && p1.z == p2.z
end

"""
==(poly1::Polygon, poly2::Polygon)
Returns a boolean if both polygons are equal.
"""
function ==(poly1::Polygon, poly2::Polygon)
    length(poly1.pts)==length(poly2.pts) &&
    all(==(p1,p2) for (p1,p2) in zip(poly1.pts,poly2.pts))
end


"""
Base.show(io::IO,p::Polygon)
This function outputs just the points for the polygon into a vector.
"""
Base.show(io::IO,p::Polygon) = print(io,string("[",join(p.pts,", "),"]"))

"""
distance(p1::Point2D,p2::Point2D)
Takes in two, 2-dimensional points and calculates the distannce between them into a float.
"""
function distance(p1::Point2D,p2::Point2D)
    sqrt((p2.x-p1.x)^2 + (p2.y-p1.y)^2)
end

"""
distance(p1::Point3D,p2::Point3D)
Takes in two, 3-dimensional points and calculates the distance between them into a float.
"""
function distance(p1::Point3D,p2::Point3D)
    sqrt((p2.x-p1.x)^2 + (p2.y-p1.y)^2 + (p2.z-p1.z)^2)
end

"""
perimeter(poly::Polygon)
Takes in a polygon, calculates the distance between the points, adds result together, and returns the perimeter of the polygon.
"""
function perimeter(poly::Polygon)
    n = length(poly.pts)
    perim = 0.0
    for i in 1:n-1
       t = distance(poly.pts[i],poly.pts[i+1])
       perim += t
    end
    perim+=distance(poly.pts[n],poly.pts[1])
    return perim
 end

"""
isRectangular(poly::Polygon)
Takes in a polygon to check if it is a rectangle. Returns false if 'length(poly.pts) !=4'. Returns true if 'distance(poly.pts[1],poly.pts[3])'
and 'distance(poly.pts[2],poly.pts[4])' are approximately the same.
"""
function isRectangular(poly::Polygon)
    if length(poly.pts) !=4
       return false
    end
    a = distance(poly.pts[1],poly.pts[3])
    b = distance(poly.pts[2],poly.pts[4])
    return isapprox(a,b)
end

"""
area(poly::Polygon)
Takes in a polygon to return its area. Multiplies each x1 and y2 value, adds them together, and multiples each x2 and y1 value which are added.
This absolute value of this result is multiplied by 0.5 to return area.
"""
function area(poly::Polygon)
    n = length(poly.pts)
    sum = 0.0
    for i in 1:n-1
        x1,y1 = poly.pts[i].x, poly.pts[i].y
        x2,y2 = poly.pts[i+1].x, poly.pts[i+1].y
        sum += (x1*y2 - y1*x2)
    end
    0.5* abs(sum)
end

"""
```
midpoint(p::Polyon)
```
calculates the midpoint of the polygon.
"""
midpoint(p::Polygon) = Point2D(mean(map(pt -> pt.x, p.points)), mean(map(pt -> pt.y, p.points)))


end #Geometry module