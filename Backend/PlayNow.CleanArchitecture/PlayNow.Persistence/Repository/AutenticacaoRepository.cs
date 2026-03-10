using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using PlayNow.Domain.Entities;
using PlayNow.Domain.Interfaces;
using PlayNow.Persistence.Context;

namespace PlayNow.Persistence.Repository
{
    public class AutenticacaoRepository : IAutenticacaoRepository
    {
        private readonly PlayNowDbContext _context;

        public AutenticacaoRepository(PlayNowDbContext context)
        {
            _context = context;
        }

        public async Task<Usuario> BuscarPorEmail(string email)
        {
            return await _context.Usuarios.FirstOrDefaultAsync(u => u.Email == email);
        }
    }
}
