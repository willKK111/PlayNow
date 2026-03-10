using Microsoft.EntityFrameworkCore;
using PlayNow.Domain.Entities;
using PlayNow.Domain.Interfaces;
using PlayNow.Persistence.Context;

namespace PlayNow.Persistence.Repository
{
    public class ReservaRepository : IReservaRepository
    {
        private readonly PlayNowDbContext _context;

        public ReservaRepository(PlayNowDbContext context)
        {
            _context = context;
        }

        public async Task<Reserva?> BuscarPorId(int id)
        {
            return await _context.Reservas
            .Include(r => r.PessoasReservas)
            .FirstOrDefaultAsync(r => r.IdReserva == id);
        }

        public async Task<bool> Cancelar(int id)
        {
            var reserva = await _context.Reservas.FindAsync(id);
            if (reserva == null) return false;

            reserva.Cancelado = true;

            _context.Reservas.Update(reserva);

            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<Reserva> Incluir(Reserva reserva)
        {
            _context.Reservas.Add(reserva);
            await _context.SaveChangesAsync();
            return reserva;
        }

        public async Task<List<Reserva>> ListarReservas()
        {
            return await _context.Reservas.Include(r => r.PessoasReservas).ToListAsync();
        }

        public Dictionary<string, List<string>> ObterHorariosDisponiveis(DateTime data)
        {
            var quadras = _context.Quadras.ToList();

            // horários fixos (ex: 8h às 22h)
            var horariosFixos = Enumerable.Range(8, 15)
                .Select(h => TimeOnly.FromTimeSpan(TimeSpan.FromHours(h)))
                .ToList();

            var resultado = new Dictionary<string, List<string>>();

            foreach (var quadra in quadras)
            {
                var reservas = _context.Reservas
                    .Where(r => r.IdQuadra == quadra.IdQuadra
                                && r.DataHora.HasValue
                                && r.DataHora.Value.Date == data.Date
                                && (!r.Cancelado)) // <=== aqui filtramos só as reservas ativas
                    .AsEnumerable()
                    .Select(r => TimeOnly.FromDateTime(r.DataHora.Value))
                    .ToList();

                var disponiveis = horariosFixos
                    .Where(h => !reservas.Contains(h))
                    .Select(h => h.ToString("HH\\:mm"))
                    .ToList();

                resultado.Add(quadra.Nome, disponiveis);
            }

            return resultado;
        }


        public async Task<bool> QuadraDisponivel(int idQuadra, DateTime dataHora)
        {
            return !await _context.Reservas
           .AnyAsync(r => r.IdQuadra == idQuadra && r.DataHora == dataHora);
        }
    }
}
