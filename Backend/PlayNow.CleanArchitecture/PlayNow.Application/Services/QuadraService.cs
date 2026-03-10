using AutoMapper;
using PlayNow.Domain.DTOs;
using PlayNow.Domain.Entities;
using PlayNow.Domain.Interfaces;

namespace PlayNow.Application.Services
{
    public class QuadraService : IQuadraService
    {

        private readonly IQuadraRepository _repository;
        private readonly ICategoriaRepository _categoriaRepository;
        private readonly IMapper _mapper;

        public QuadraService(IQuadraRepository repository, IMapper mapper, ICategoriaRepository categoriaRepository)
        {
            _repository = repository;
            _mapper = mapper;
            _categoriaRepository = categoriaRepository;
        }

        public async Task<(bool, QuadraDTO)> Alterar(int id, QuadraDTO quadraDTO)
        {
            var quadra = await _repository.SelecionarPorId(id);
            var categoriaExiste = await _categoriaRepository.SelecionarPorId(quadraDTO.idCategoria);
            if (categoriaExiste == null)
            {
                return (false, null);
            }

            if (quadra == null)
            {
                var novaQuadra = _mapper.Map<Quadra>(quadraDTO);
                var quadraCriada = await _repository.Incluir(novaQuadra);
                return (true, _mapper.Map<QuadraDTO>(quadraCriada));
            }
            else
            {
                _mapper.Map(quadraDTO, quadra);
                var quadraAlterada = await _repository.Alterar(quadra);
                return (false, _mapper.Map<QuadraDTO>(quadraAlterada));
            }
        }

        public async Task<Quadra> Excluir(int id)
        {
            var quadraExcluida = await _repository.Excluir(id);

            if (quadraExcluida == null) {
                return null;
            }
            return quadraExcluida;
        }


        // fazer verificacao se a categoria existe 
        public async Task<QuadraDTO> Incluir(QuadraDTO quadraDTO)
        {
            var categoriaExiste = await _categoriaRepository.SelecionarPorId(quadraDTO.idCategoria);
            if (categoriaExiste == null)
            {
                return null;
            }

            var quadra = _mapper.Map<Quadra>(quadraDTO);
            var quadraIncluida = await _repository.Incluir(quadra);
            return _mapper.Map<QuadraDTO>(quadraIncluida);
        }

        public async Task<QuadraGetDTO> SelecionarPorId(int id)
        {
            var quadra = await _repository.SelecionarPorId(id);
            if(quadra == null)
            {
                return null;
            }

            var categoria = await _categoriaRepository.SelecionarPorId(quadra.IdCategoria);

            var quadraGet = _mapper.Map<QuadraGetDTO>(quadra);
            quadraGet.Categoria = categoria;

            return quadraGet;
        }

        public async Task<IEnumerable<QuadraGetDTO>> SelecionarTodos()
        {
            var listaTodos = await _repository.SelecionarTodos();
            var quadrasGet = new List<QuadraGetDTO>();
     
            foreach (var quadra in listaTodos)
            {
                var categoria = await _categoriaRepository.SelecionarPorId(quadra.IdCategoria);
                var quadraGet = _mapper.Map<QuadraGetDTO>(quadra);
                quadraGet.Categoria = categoria;
                quadrasGet.Add(quadraGet);
            }

            return quadrasGet;
        }
    }
}
