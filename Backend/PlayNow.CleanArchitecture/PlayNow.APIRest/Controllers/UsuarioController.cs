using Microsoft.AspNetCore.Mvc;
using PlayNow.Domain.DTOs;
using PlayNow.Domain.Entities;
using PlayNow.Domain.Interfaces;

namespace PlayNow.APIRest.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class UsuarioController : ControllerBase
    {

        private readonly IUsuarioService _service;

        public UsuarioController(IUsuarioService service)
        {
            _service = service;

        }

        [HttpGet("selecionarTodos")]
        public async Task<ActionResult<IEnumerable<Usuario>>> selecionarTodosOsUsuarios()
        {
            var usuariosDTO = await _service.SelecionarTodos();
            return Ok(usuariosDTO);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult> selecionarUsuario(int id)
        {
            var usuarioDTO = await _service.SelecionarPorId(id);

            if(usuarioDTO == null)
            {
                return NotFound("Usuário não encontrado.");
            }

            return Ok(usuarioDTO);
        }

        [HttpPost]
        public async Task<ActionResult> CadastrarUsuario(UsuarioDTO usuarioDTO)
        {
            if(!ModelState.IsValid)
            {
                var erros = ModelState
                    .Where(e => e.Value.Errors.Count > 0)
                    .ToDictionary(
                        kvp => kvp.Key,
                        kvp => kvp.Value.Errors.Select(e => e.ErrorMessage).ToArray()
                );

                return BadRequest(new {erros});
            }

            var usuario = await _service.Incluir(usuarioDTO);

            if(usuario == null)
            {
                return BadRequest("Ocorreu um erro ao cadastrar o usuário.");
            }
            return Ok("Usuário cadastrado com sucesso.");

        }

        [HttpPut("{id}")]
        public async Task<ActionResult> AlterarUsuarioPut(int id, [FromBody] UsuarioDTO usuarioDTO)
        {
            if(!ModelState.IsValid)
            {
                var erros = ModelState
                    .Where(e => e.Value.Errors.Count > 0)
                    .ToDictionary(
                        kvp => kvp.Key,
                        kvp => kvp.Value.Errors.Select(e => e.ErrorMessage).ToArray()
                );

                return BadRequest(new { erros });
            }

            var (criado, usuario) = await _service.AlterarCompleto(id, usuarioDTO);

  
            if(usuario == null)
            {
                return BadRequest("Ocorreu um erro ao alterar usuário.");
            }
            else if(criado) {
                return Ok("Usuário cadastrado.");
            }
            return Ok("Usuário alterado com sucesso.");
        }

        [HttpPatch("{id}")]
        public async Task<ActionResult> AlterarUsuarioPatch(int id, [FromBody] UsuarioPatchDTO usuarioPatchDTO)
        {
            if(!ModelState.IsValid)
            {
                var erros = ModelState
                    .Where(e => e.Value.Errors.Count > 0)
                    .ToDictionary(
                        kvp => kvp.Key,
                        kvp => kvp.Value.Errors.Select(e => e.ErrorMessage).ToArray()
                );

                return BadRequest(new { erros });
            }

            var (deletado, usuario) = await _service.AlterarParcial(id, usuarioPatchDTO);

            if(usuario == null)
            {
                if (deletado)
                    return BadRequest("Usuário foi deletado.");
                else
                    return NotFound("Usuário não encontrado.");
            }
            return Ok("Usuário alterado com sucesso.");
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> ExcluirUsuario(int id)
        {
            var usuario = await _service.Excluir(id);

            if(usuario == null)
            {
                return BadRequest("Ocorreu um erro ao excluir o usuário.");
            }
            return Ok("Usuário excluído com sucesso.");
        }
    }
}
