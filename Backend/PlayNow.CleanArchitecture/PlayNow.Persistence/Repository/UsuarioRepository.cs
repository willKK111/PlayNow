using Microsoft.EntityFrameworkCore;
using PlayNow.Domain.Entities;
using PlayNow.Domain.Interfaces;
using PlayNow.Persistence.Context;

namespace PlayNow.Persistence.Repository
{
    public class UsuarioRepository : IUsuarioRepository
    {
        private readonly PlayNowDbContext _context;

        public UsuarioRepository(PlayNowDbContext context)
        {
            _context = context;
        }

        public async Task<Usuario> Alterar(Usuario usuario)
        {
            _context.Usuarios.Update(usuario);

            await _context.SaveChangesAsync();
            return usuario;
        }

        public async Task<Usuario> Incluir(Usuario usuario)
        {
            _context.Usuarios.Add(usuario);
            await _context.SaveChangesAsync();
            return usuario;
        }

        public async Task<IEnumerable<Usuario>> SelecionarTodos()
        {
            var usuarios = await _context.Usuarios.ToListAsync();
            return usuarios;
        }

        public async Task<Usuario> SelecionarPorId(int id)
        {
            var usuario = await _context.Usuarios.Where(x => x.IdUsuario == id).FirstOrDefaultAsync(); // recuperando o primeiro resultado
            return usuario;
        }
    }
}
