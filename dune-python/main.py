import discord
import os
from dotenv import load_dotenv
from discord.ext import commands
from db_connect import connect_db

load_dotenv()
TOKEN = os.getenv('DISCORD_TOKEN')

intents = discord.Intents.default()
intents.members = True

bot = commands.Bot(command_prefix='.', intents=intents, case_insensitive=True)
db = connect_db()
client = discord.Client()

@bot.event
async def on_ready():
  print(f'Bot connected as {bot.user.name} {bot.user.id}')
  print('------------')


@bot.command(help='Test function for validation')
async def test(ctx):
  """Test function to make sure everything is groovy"""
  await ctx.send("Dune bot is up and running smoothly...")


bot.run(TOKEN)
