#!/bin/bash
set -ex

# Send logs to file
exec > /home/ec2-user/setup.log 2>&1

echo "===== START SETUP ====="

# 🔥 FIX: Set environment variables required by dotnet
export HOME=/home/ec2-user
export USER=ec2-user

# Update system
dnf update -y

# Install required packages
dnf install -y git mariadb105 libicu

# Install .NET 8 SDK
rpm --import https://packages.microsoft.com/keys/microsoft.asc
dnf install -y dotnet-sdk-8.0

# Verify installation
dotnet --version

# Switch to ec2-user home
cd /home/ec2-user

# Create .NET Web API project
dotnet new webapi -n ProductInventory --no-openapi
cd ProductInventory

# Add required packages
dotnet add package Microsoft.EntityFrameworkCore --version 8.0.0
dotnet add package Pomelo.EntityFrameworkCore.MySql --version 8.0.0
dotnet add package Microsoft.EntityFrameworkCore.Design --version 8.0.0

# Remove default files
rm -f Controllers/WeatherForecastController.cs
rm -f WeatherForecast.cs

# Create folders
mkdir -p Models Data Controllers

# -------------------------
# Product Model
# -------------------------
cat <<EOT > Models/Product.cs
namespace ProductInventory.Models;

public class Product
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Category { get; set; } = string.Empty;
    public decimal Price { get; set; }
    public int Quantity { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}
EOT

# -------------------------
# DbContext
# -------------------------
cat <<EOT > Data/AppDbContext.cs
using Microsoft.EntityFrameworkCore;
using ProductInventory.Models;

namespace ProductInventory.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options) { }

    public DbSet<Product> Products { get; set; }
}
EOT

# -------------------------
# Controller
# -------------------------
cat <<EOT > Controllers/ProductsController.cs
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ProductInventory.Data;
using ProductInventory.Models;

namespace ProductInventory.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    private readonly AppDbContext _db;

    public ProductsController(AppDbContext db) { _db = db; }

    [HttpGet]
    public async Task<IActionResult> GetAll() =>
        Ok(await _db.Products.ToListAsync());

    [HttpGet("{id}")]
    public async Task<IActionResult> Get(int id)
    {
        var p = await _db.Products.FindAsync(id);
        return p == null ? NotFound() : Ok(p);
    }

    [HttpPost]
    public async Task<IActionResult> Create(Product p)
    {
        _db.Products.Add(p);
        await _db.SaveChangesAsync();
        return Ok(p);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(int id, Product u)
    {
        var p = await _db.Products.FindAsync(id);
        if (p == null) return NotFound();

        p.Name = u.Name;
        p.Category = u.Category;
        p.Price = u.Price;
        p.Quantity = u.Quantity;

        await _db.SaveChangesAsync();
        return Ok(p);
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(int id)
    {
        var p = await _db.Products.FindAsync(id);
        if (p == null) return NotFound();

        _db.Products.Remove(p);
        await _db.SaveChangesAsync();
        return Ok("Deleted");
    }
}
EOT

# -------------------------
# Program.cs
# -------------------------
cat <<EOT > Program.cs
using Microsoft.EntityFrameworkCore;
using ProductInventory.Data;

var builder = WebApplication.CreateBuilder(args);

var conn = "Server=${DB_HOST};Port=3306;Database=productdb;User=${DB_USER};Password=${DB_PASSWORD};";

builder.Services.AddDbContext<AppDbContext>(opt =>
    opt.UseMySql(conn, ServerVersion.AutoDetect(conn)));

builder.Services.AddControllers();

var app = builder.Build();

using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    db.Database.EnsureCreated();
}

app.MapControllers();

app.Run("http://0.0.0.0:5001");
EOT

# Build project
dotnet build

# Run app in background
nohup dotnet run --urls "http://0.0.0.0:5001" > app.log 2>&1 &

echo "===== SETUP COMPLETE ====="