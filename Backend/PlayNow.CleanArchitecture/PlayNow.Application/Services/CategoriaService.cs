
using AutoMapper;
using PlayNow.Domain.DTOs;
using PlayNow.Domain.Entities;
using PlayNow.Domain.Interfaces;

namespace PlayNow.Application.Services
{
    public class CategoriaService : ICategoriaService
    {
        private readonly ICategoriaRepository _repository;
        private readonly IMapper _mapper;

        public CategoriaService(ICategoriaRepository repository, IMapper mapper)
        {
            _repository = repository;
            _mapper = mapper;
        }

        public async Task<(bool, CategoriaDTO)> Alterar(int id, CategoriaDTO categoriaDTO)
        {

            var categoria = await _repository.SelecionarPorId(id);

            if (categoria == null)
            {
                var novaCategoria = _mapper.Map<Categoria>(categoriaDTO);
                var categoriaCriada = await _repository.Incluir(novaCategoria);
                return (true, _mapper.Map<CategoriaDTO>(categoriaCriada));
            }
            else
            {
                _mapper.Map(categoriaDTO, categoria);
                var categoriaAlterada = await _repository.Alterar(categoria);
                return (false, _mapper.Map<CategoriaDTO>(categoriaAlterada));
            }

        }

        public async Task<Categoria> Excluir(int id)
        {
            var categoriaExcluida = await _repository.Excluir(id);
            if(categoriaExcluida == null)
            {
                return null;
            }
            return categoriaExcluida;
        }

        public async Task<CategoriaDTO> Incluir(CategoriaDTO categoriaDTO)
        {
            var categoria = _mapper.Map<Categoria>(categoriaDTO);
            var categoriaIncluida = await _repository.Incluir(categoria);
            return _mapper.Map<CategoriaDTO>(categoriaIncluida);
        }

        public async Task<Categoria> SelecionarPorId(int id)
        {
            return await _repository.SelecionarPorId(id);
        }

        public async Task<IEnumerable<Categoria>> SelecionarTodos()
        {
            return await _repository.SelecionarTodos();
        }

    }
}
