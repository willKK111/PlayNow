using AutoMapper;
using PlayNow.Domain.DTOs;
using PlayNow.Domain.Entities;
using PlayNow.Domain.Interfaces;

namespace PlayNow.Application.Services
{
    public class ReservaService : IReservaService
    {
        private readonly IReservaRepository _repository;
        private readonly IMapper _mapper;

        public ReservaService(IReservaRepository repository, IMapper mapper)
        {
            _repository = repository;
            _mapper = mapper;
        }

        public async Task<ReservaGetDTO?> BuscarPorId(int id)
        {
            var reserva = await _repository.BuscarPorId(id);

            return _mapper.Map<ReservaGetDTO>(reserva);
        }

        public async Task<bool> Cancelar(int id)
        {
            return await _repository.Cancelar(id);
        }


        public async Task<ReservaDTO> Incluir(ReservaDTO dto)
        {
            dto.DataHora = new DateTime(dto.DataHora.Year, dto.DataHora.Month, dto.DataHora.Day, dto.DataHora.Hour, 0, 0);


            if (!await _repository.QuadraDisponivel(dto.IdQuadra, dto.DataHora))
                throw new Exception("Quadra já reservada para o horário informado.");

            var reserva = _mapper.Map<Reserva>(dto);

            var entity = await _repository.Incluir(reserva);

            return _mapper.Map<ReservaDTO>(entity);
        }

        public async Task<List<ReservaGetDTO>> ListarReservas()
        {
            var reservas = await _repository.ListarReservas();
            return _mapper.Map<List<ReservaGetDTO>>(reservas);
        }

        public Dictionary<string, List<string>> ObterHorariosDisponiveis(DateTime data)
        {
            return _repository.ObterHorariosDisponiveis(data);
        }

        public async Task<bool> QuadraDisponivel(int idQuadra, DateTime dataHora)
        {
            return await _repository.QuadraDisponivel(idQuadra, dataHora);
        }
    }
}
