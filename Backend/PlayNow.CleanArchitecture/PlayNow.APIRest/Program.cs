using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using PlayNow.Application.Mappings;
using PlayNow.Application.Services;
using PlayNow.Domain.Interfaces;
using PlayNow.Persistence.Context;
using PlayNow.Persistence.Repository;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle

// definindo as configurações de interface e quem a implementa para ser possível a injeção de dependência
builder.Services.AddScoped<IUsuarioRepository, UsuarioRepository>(); 
builder.Services.AddScoped<IUsuarioService, UsuarioService>();
builder.Services.AddScoped<ICategoriaRepository, CategoriaRepository>();
builder.Services.AddScoped<ICategoriaService, CategoriaService>();
builder.Services.AddScoped<IQuadraRepository, QuadraRepository>();
builder.Services.AddScoped<IQuadraService, QuadraService>();
builder.Services.AddScoped<IAutenticacaoRepository, AutenticacaoRepository>();
builder.Services.AddScoped<IAutenticacaoService, AutenticacaoService>();
builder.Services.AddScoped<IReservaRepository, ReservaRepository>();
builder.Services.AddScoped<IReservaService, ReservaService>();

builder.Services.AddAutoMapper(typeof(EntitiesToDTOMappingProfile));

// Desativa a resposta automática de 400 Bad Request em caso de erro de validação.
// Isso permite que a validação do ModelState seja tratada manualmente nos controllers,
// possibilitando a personalização das mensagens de erro retornadas para o cliente.
builder.Services.Configure<ApiBehaviorOptions>(options =>
{
    options.SuppressModelStateInvalidFilter = true;
});


builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    options.SwaggerDoc("v1", new OpenApiInfo
    {
        Version = "Versão .NET 8.0",
        Title = "APIRest PlayNow",
        Description = "APIRest criada servindo de Backend para o projeto mobile feito em Flutter",
        Contact = new OpenApiContact
        {
            Name = "Daniele Querino",
            Email = "danisq77@gmail.com",
        }
    });
});


builder.Services.AddDbContext<PlayNowDbContext>(options =>
{
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"));
});

var app = builder.Build();

app.UseCors(x => x.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader());



// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
}

app.UseSwagger();
app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "APIRest PlayNow"));

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
