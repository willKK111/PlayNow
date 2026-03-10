using Microsoft.EntityFrameworkCore;
using PlayNow.Domain.Entities;
using PlayNow.Domain.Interfaces;
using PlayNow.Persistence.Context;

namespace PlayNow.Persistence.Repository
{
    public class CategoriaRepository : ICategoriaRepository
    {
        private readonly PlayNowDbContext _context;

        public CategoriaRepository(PlayNowDbContext context)
        {
            _context = context;
        }

        public async Task<Categoria> Alterar(Categoria categoria)
        {
            _context.Categorias.Update(categoria);

            await _context.SaveChangesAsync();
            return categoria;
        }

        public async Task<Categoria> Excluir(int id)
        {
            var categoria = await SelecionarPorId(id);

            if(categoria == null)
            {
                return null;
            }
            _context.Categorias.Remove(categoria);
            await _context.SaveChangesAsync();
            return categoria;
        }

        public async Task<Categoria> Incluir(Categoria categoria)
        {
            _context.Categorias.Add(categoria);
            await _context.SaveChangesAsync();
            return categoria;
        }

        public async Task<Categoria> SelecionarPorId(int id)
        {
            var categoria = await _context.Categorias.Where(x => x.IdCategoria == id).FirstOrDefaultAsync(); // recuperando o primeiro resultado
            return categoria;
        }

        public async Task<IEnumerable<Categoria>> SelecionarTodos()
        {
            var categorias = await _context.Categorias.ToListAsync();
            return categorias;
        }
    }
}

