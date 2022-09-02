using Microsoft.AspNetCore.Mvc;

namespace HelloApi.Controllers;

[ApiController]
[Route("[controller]")]
public class HelloWorldController : ControllerBase
{
    private readonly ILogger<HelloWorldController> _logger;

    public HelloWorldController(ILogger<HelloWorldController> logger)
    {
        _logger = logger;
    }

    [HttpGet(Name = "HelloWorld")]
    public HelloWorld Get()
    {
        return new HelloWorld
        {
            Date = DateTime.Now,
            Hello = "World !"
        };
    }
}
