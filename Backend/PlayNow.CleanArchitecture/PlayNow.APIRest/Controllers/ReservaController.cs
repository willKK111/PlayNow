using Microsoft.AspNetCore.Mvc;
using PlayNow.Domain.DTOs;
using PlayNow.Domain.Interfaces;

namespace PlayNow.APIRest.Controllers
{

    [ApiController]
    [Route("[controller]")]
    public class ReservaController : ControllerBase
    {

        private readonly IReservaService _service;

        public ReservaController(IReservaService service)
        {
            _service = service;
        }

        [HttpGet("horarios-disponiveis")]
        public IActionResult GetHorariosDisponiveis([FromQuery] DateTime data)
        {
            var horariosDisponiveis = _service.ObterHorariosDisponiveis(data);
            return Ok(horariosDisponiveis);
        }


        [HttpGet("selecionarTodas")]
        public async Task<IActionResult> selecionarTodasAsReservas()
        {
            var reservas = await _service.ListarReservas();
            return Ok(reservas);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> SelecionarReserva(int id)
        {
            var reserva = await _service.BuscarPorId(id);
            if (reserva == null) return NotFound("Reserva não encontrada.");
            return Ok(reserva);
        }

        [HttpPost]
        public async Task<IActionResult> CadastrarReserva([FromBody] ReservaDTO dto)
        {
            try
            {
                var reserva = await _service.Incluir(dto);
                return Ok("Reserva cadastrada com sucesso.");
                //return CreatedAtAction(nameof(Get), new { id = reserva.IdReserva }, reserva);
            }
            catch (Exception ex)
            {
                return BadRequest(new { erro = ex.Message });
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Cancelar(int id)
        {
            if (await _service.Cancelar(id))
            {
                return Ok("Reserva cancelada com sucesso.");
            }

            return NotFound("Reserva não encontrada.");
        }



    }
}
