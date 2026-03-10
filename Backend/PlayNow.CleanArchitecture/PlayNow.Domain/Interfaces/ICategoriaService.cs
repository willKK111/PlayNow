using PlayNow.Domain.DTOs;
using PlayNow.Domain.Entities;

namespace PlayNow.Domain.Interfaces
{
    public interface ICategoriaService
    {
        Task<CategoriaDTO> Incluir(CategoriaDTO categoriaDTO);
        Task<(bool, CategoriaDTO)> Alterar(int id, CategoriaDTO categoriaDTO);
        Task<Categoria> Excluir(int id);
        Task<Categoria> SelecionarPorId(int id);
        Task<IEnumerable<Categoria>> SelecionarTodos();
    }
}
