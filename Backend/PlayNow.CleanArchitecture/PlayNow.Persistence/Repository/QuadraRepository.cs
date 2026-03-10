using Microsoft.EntityFrameworkCore;
using PlayNow.Domain.Entities;
using PlayNow.Domain.Interfaces;
using PlayNow.Persistence.Context;

namespace PlayNow.Persistence.Repository
{
    public class QuadraRepository : IQuadraRepository
    {
        private readonly PlayNowDbContext _context;


        public QuadraRepository(PlayNowDbContext context)
        {
            _context = context;
        }

        public async Task<Quadra> Alterar(Quadra quadra)
        {
            _context.Quadras.Update(quadra);
            await _context.SaveChangesAsync();
            return quadra;
        }

        public async Task<Quadra> Excluir(int id)
        {
            var quadra = await SelecionarPorId(id);

            if(quadra == null)
            {
                return null;
            }
            _context.Quadras.Remove(quadra);
            await _context.SaveChangesAsync();
            return quadra;
        }

        public async Task<Quadra> Incluir(Quadra quadra)
        {
            _context.Quadras.Add(quadra);
            await _context.SaveChangesAsync();
            return quadra;
        }

        public async Task<Quadra> SelecionarPorId(int id)
        {
            var quadra = await _context.Quadras.Where(x => x.IdQuadra == id).FirstOrDefaultAsync(); // recuperando o primeiro resultado
            return quadra;
        }

        public async Task<IEnumerable<Quadra>> SelecionarTodos()
        {
            var quadras = await _context.Quadras.ToListAsync();
            return quadras;
        }
    }
}
