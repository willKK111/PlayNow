using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using PlayNow.Domain.Entities;

namespace PlayNow.Persistence.Context;


public partial class PlayNowDbContext : DbContext
{

    private readonly IConfiguration _configuration;
    public PlayNowDbContext()
    {
    }

    public PlayNowDbContext(DbContextOptions<PlayNowDbContext> options, IConfiguration configuration)
        : base(options)
    {
        _configuration = configuration;
    }

    public virtual DbSet<Categoria> Categorias { get; set; }

    public virtual DbSet<Usuario> Usuarios { get; set; }

    public virtual DbSet<Quadra> Quadras { get; set; }

    public virtual DbSet<Reserva> Reservas { get; set; }

    public virtual DbSet<PessoasReserva> PessoasReservas { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer(_configuration.GetConnectionString("DefaultConnection"));

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Quadra>(entity =>
        {
            entity.HasKey(e => e.IdQuadra).HasName("PK__Quadras__6E2394B4F695DF01");
            entity.Property(e => e.Nome).HasMaxLength(100);
            entity.HasIndex(e => e.Numero, "UQ__Quadras__7E532BC6CEC3C56D").IsUnique();
            entity.Property(e => e.IdCategoria).HasColumnName("idCategoria");
        });

        modelBuilder.Entity<Categoria>(entity =>
        {
            entity.HasKey(e => e.IdCategoria).HasName("PK__Categori__A3C02A10D20108A4");

            entity.Property(e => e.Nome)
                .HasMaxLength(100)
                .IsUnicode(false);
        });

        modelBuilder.Entity<Usuario>(entity =>
        {
            entity.HasKey(e => e.IdUsuario).HasName("PK__Usuarios__5B65BF97A534143F");

            entity.HasIndex(e => e.Email, "UQ__Usuarios__A9D105345AF47BA4").IsUnique();

            entity.Property(e => e.Email)
                .HasMaxLength(150)
                .IsUnicode(false);
            entity.Property(e => e.Nome)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.Senha)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.Telefone)
                .HasMaxLength(20)
                .IsUnicode(false);
        });

        modelBuilder.Entity<PessoasReserva>(entity =>
        {
            entity.HasKey(e => e.IdPessoa).HasName("PK__PessoasR__7061465D58A8594F");

            entity.ToTable("PessoasReserva");

            entity.Property(e => e.Nome).HasMaxLength(100);

            entity.HasOne(d => d.IdReservaNavigation).WithMany(p => p.PessoasReservas)
                .HasForeignKey(d => d.IdReserva)
                .HasConstraintName("FK__PessoasRe__IdRes__06CD04F7");
        });

        modelBuilder.Entity<Reserva>(entity =>
        {
            entity.HasKey(e => e.IdReserva).HasName("PK__Reservas__0E49C69D8607DF7C");

            entity.Property(e => e.DataHora).HasColumnType("datetime");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
