using Test, Statistics
import Base.==

@testset "Same Type Test" begin
    p1 = Point2D(1,2)
    p2 = Point2D(1,2)
    p3 = Point2D(1,3)
    @test p1 == p2
    p1 = Point3D(1,2,3)
    p2 = Point3D(1,2,3)
    p3 = Point3D(1,3,4)
    @test p1 == p2
    p1 = Point2D(0,0)
    p2 = Point2D(1,2)
    p3 = Point2D(3,4)
    p4 = Point2D(4,5)
    poly1 = Polygon([p1,p2,p3])
    poly2 = Polygon([p1,p2,p3])
    poly3 = Polygon([p1,p2,p4])
    @test poly1 == poly2
end;

@testset "Point2D Type Test" begin
    @test isa(Point2D(1,2),Point2D)
    @test isa(Point2D(3,4),Point2D)
    @test isa(Point2D(1.2,3.4),Point2D)
    @test isa(Point2D(5.4,5.6),Point2D)
    @test isa(Point2D("(1,2)"), Point2D)
end;

@testset "Point2D String Test" begin
    @test Point2D("(1,2)") == Point2D(1,2)
    @test Point2D("(1.2,3.4)") == Point2D(1.2,3.4)
    @test Point2D("(1.2,3)") == Point2D(1.2,3)
end;

@testset "Point3D Type Test" begin
    @test isa(Point3D(1,2,3),Point3D)
    @test isa(Point3D(3,4,5),Point3D)
    @test isa(Point3D(1.2,3.4,5.4),Point3D)
    @test isa(Point3D(5.4,5.6,6.7),Point3D)
    @test isa(Point3D(1.2,2,3), Point3D)
end;

@testset "Polygon Type Test" begin #e
    @test isa(Polygon([Point2D(0,0),Point2D(2,2),Point2D(8,2),Point2D(6,0)]),Polygon)
    @test isa(Polygon([0,0,0,1,1,0]),Polygon)
    @test isa(Polygon(0,0,0,2,1,2,1,0),Polygon)
end;

@testset "Polygon Constructor Test" begin #f
    square = Polygon([Point2D(0,0),Point2D(0,1),Point2D(1,1),Point2D(1,0)])
    @test Polygon([Point2D(0,0),Point2D(0,1),Point2D(1,1),Point2D(1,0)]) == square
    @test Polygon([0,0,0,1,1,1,1,0]) == square
    @test Polygon(0,0,0,1,1,1,1,0) == square
end;

@testset "Polygon Error Test" begin
    @test_throws ArgumentError Polygon([Point2D(0,0),Point2D(2,2)])
    @test_throws ArgumentError Polygon([1,2,3,4,5,6,7])
    @test_throws ArgumentError Polygon(1,2,3,4,5,6,7,8,9)
end

right_triangle =Polygon([Point2D(0,0),Point2D(0,1),Point2D(1,0)])

rectangle = Polygon([Point2D(0,0),Point2D(0,2),Point2D(1,2),Point2D(1,0)])

parallelogram = Polygon([Point2D(0,0),Point2D(2,2),Point2D(8,2),Point2D(6,0)])

@testset "Distance Test" begin
    @test isapprox(distance(Point2D(-2,-2),Point2D(2,6)), sqrt((2+2)^2 + (6+2)^2))
    @test isapprox(distance(Point2D(-1,-2),Point2D(-3,-4)), sqrt((-3+1)^2 + (-4+2)^2))
    @test isapprox(distance(Point2D(3,4),Point2D(2,2)), sqrt((2-4)^2 + (2-3)^2))
end;

@testset "Perimeter Test" begin
    @test isapprox(perimeter(right_triangle), 1 + 1 + sqrt(2))
    @test isapprox(perimeter(parallelogram), 2*(2*sqrt(2) + 6))
    @test isapprox(perimeter(rectangle), 2*(2+1))
end;

@testset "Area Test" begin
    @test isapprox(area(right_triangle), 0.5*1*1)
    @test isapprox(area(parallelogram), abs(2*0 - 2*6))
    @test isapprox(area(rectangle), 1*2)
end;

@testset "Midpoint caclulations" begin
    @test midpoint(triangle) == Point2D(1/3,1/3)
    @test midpoint(rectangle) == Point2D(0.5,1)
end
