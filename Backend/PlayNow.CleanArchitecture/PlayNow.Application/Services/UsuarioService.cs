using AutoMapper;
using PlayNow.Domain.DTOs;
using PlayNow.Domain.Entities;
using PlayNow.Domain.Interfaces;

namespace PlayNow.Application.Services
{
    public class UsuarioService : IUsuarioService
    {
        private readonly IUsuarioRepository _repository;
        private readonly IMapper _mapper;

        public UsuarioService(IUsuarioRepository repository, IMapper mapper)
        {
            _repository = repository;
            _mapper = mapper;
        }

        public async Task<(bool, UsuarioDTO)> AlterarCompleto(int id, UsuarioDTO usuarioDTO)
        {
            var usuario = await _repository.SelecionarPorId(id);
            
            if(usuario == null)
            {
                var novoUsuario = _mapper.Map<Usuario>(usuarioDTO);
                var usuarioCriado = await _repository.Incluir(novoUsuario);
                return (true, _mapper.Map<UsuarioDTO>(usuarioCriado));
            }
            else
            {
                _mapper.Map(usuarioDTO, usuario);
                var usuarioAlterado = await _repository.Alterar(usuario);
                return (false, _mapper.Map<UsuarioDTO>(usuarioAlterado));
            }
        }

        public async Task<(bool, UsuarioPatchDTO)> AlterarParcial(int id, UsuarioPatchDTO usuarioPatchDTO)
        {
            var usuario = await _repository.SelecionarPorId(id);

            if(usuario == null) return (false, null);         
            if(usuario.Deletado) return (true, null);   

            _mapper.Map(usuarioPatchDTO, usuario);

            var usuarioAlterado = await _repository.Alterar(usuario);
            return (false, _mapper.Map<UsuarioPatchDTO>(usuarioAlterado));
        }

        public async Task<UsuarioPatchDTO> Excluir(int id)
        {
            var usuario = await _repository.SelecionarPorId(id);

            if(usuario == null) return null;

            usuario.Deletado = true;

            var usuarioAlterado = await _repository.Alterar(usuario);
            return _mapper.Map<UsuarioPatchDTO>(usuarioAlterado);
        }

        public async Task<UsuarioDTO> Incluir(UsuarioDTO usuarioDTO)
        {
            var usuario = _mapper.Map<Usuario>(usuarioDTO);
            var usuarioIncluido = await _repository.Incluir(usuario);
            return _mapper.Map<UsuarioDTO>(usuarioIncluido);

        }

        public async Task<Usuario> SelecionarPorId(int id)
        {
            return await _repository.SelecionarPorId(id);
        }

        public async Task<IEnumerable<Usuario>> SelecionarTodos()
        {
            return await _repository.SelecionarTodos();
        }
    }
}

