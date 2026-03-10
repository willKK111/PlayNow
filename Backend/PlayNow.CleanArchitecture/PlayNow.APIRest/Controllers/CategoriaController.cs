using Microsoft.AspNetCore.Mvc;
using PlayNow.Domain.DTOs;
using PlayNow.Domain.Entities;
using PlayNow.Domain.Interfaces;

namespace PlayNow.APIRest.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class CategoriaController : ControllerBase
    {
        private readonly ICategoriaService _service;

        public CategoriaController(ICategoriaService service)
        {
            _service = service;

        }

        [HttpGet("selecionarTodas")]
        public async Task<ActionResult<IEnumerable<Categoria>>> selecionarTodasAsCategorias()
        {
            return Ok(await _service.SelecionarTodos());
        }

        [HttpGet("{id}")]
        public async Task<ActionResult> selecionarCategoria(int id)
        {
            var categoriaDTO = await _service.SelecionarPorId(id);

            if (categoriaDTO == null)
            {
                return NotFound("Categoria não encontrada.");
            }

            return Ok(categoriaDTO);
        }

        [HttpPost]
        public async Task<ActionResult> CadastrarCategoria(CategoriaDTO categoriaDTO)
        {
            if (!ModelState.IsValid)
            {
                var erros = ModelState
                    .Where(e => e.Value.Errors.Count > 0)
                    .ToDictionary(
                        kvp => kvp.Key,
                        kvp => kvp.Value.Errors.Select(e => e.ErrorMessage).ToArray()
                );

                return BadRequest(new { erros });
            }

            var categoriaIncluida = await _service.Incluir(categoriaDTO);

            if (categoriaIncluida == null)
            {
                return BadRequest("Ocorreu um erro ao cadastrar a categoria.");
            }
            return Ok("Categoria cadastrada com sucesso.");

        }

        [HttpPut("{id}")]
        public async Task<ActionResult> AlterarCategoria(int id, [FromBody] CategoriaDTO categoriaDTO)
        {
            if (!ModelState.IsValid)
            {
                var erros = ModelState
                    .Where(e => e.Value.Errors.Count > 0)
                    .ToDictionary(
                        kvp => kvp.Key,
                        kvp => kvp.Value.Errors.Select(e => e.ErrorMessage).ToArray()
                );

                return BadRequest(new { erros });
            }

            var (criado, categoriaAlterada) = await _service.Alterar(id, categoriaDTO);


            if (categoriaAlterada == null)
            {
                return BadRequest("Ocorreu um erro ao alterar categoria.");
            }
            else if (criado)
            {
                return Ok("Categoria cadastrada.");
            }
            return Ok("Categoria alterada com sucesso.");
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> ExcluirCategoria(int id)
        {
            var categoria = await _service.Excluir(id);

            if (categoria == null)
            {
                return NotFound("Categoria não encontrada.");
            }
            return Ok("Categoria excluída com sucesso.");
        }
    }
}
