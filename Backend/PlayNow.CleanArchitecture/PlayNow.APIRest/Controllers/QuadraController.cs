using Microsoft.AspNetCore.Mvc;
using PlayNow.Domain.DTOs;
using PlayNow.Domain.Entities;
using PlayNow.Domain.Interfaces;

namespace PlayNow.APIRest.Controllers
{

    [ApiController]
    [Route("[controller]")]
    public class QuadraController : ControllerBase
    {
        private readonly IQuadraService _service;

        public QuadraController(IQuadraService service)
        {
            _service = service;
        }

        [HttpGet("selecionarTodas")]
        public async Task<ActionResult<IEnumerable<Quadra>>> selecionarTodasAsQuadras()
        {
            return Ok(await _service.SelecionarTodos());
        }

        [HttpGet("{id}")]
        public async Task<ActionResult> selecionarQuadra(int id)
        {
            var quadraGetDTO = await _service.SelecionarPorId(id);

            if (quadraGetDTO == null)
            {
                return NotFound("Quadra não encontrada.");
            }

            return Ok(quadraGetDTO);
        }

        [HttpPost()]
        public async Task<ActionResult> CadastrarQuadra(QuadraDTO quadraDTO)
        {
            var quadraIncluida = await _service.Incluir(quadraDTO);

            if (quadraIncluida == null)
            {
                return BadRequest("Ocorreu um erro ao cadastrar a quadra.");
            }
            return Ok("Quadra cadastrada com sucesso.");

        }

        [HttpPut("{id}")]
        public async Task<ActionResult> AlterarQuadra(int id, [FromBody] QuadraDTO quadraDTO)
        {

            var (criado, quadraAlterada) = await _service.Alterar(id, quadraDTO);


            if (quadraAlterada == null)
            {
                return BadRequest("Ocorreu um erro ao alterar quadra.");
            }
            else if (criado)
            {
                return Ok("Quadra cadastrada.");
            }
            return Ok("Quadra alterada com sucesso.");
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> ExcluirQuadra(int id)
        {
            var quadra = await _service.Excluir(id);

            if (quadra == null)
            {
                return NotFound("Quadra não encontrada.");
            }
            return Ok("Quadra excluída com sucesso.");
        }
    }
}
