FROM mcr.microsoft.com/dotnet/core/aspnet:2.2 AS base
WORKDIR /app
EXPOSE 82

FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build
WORKDIR /src
COPY ["samplecoreapp.csproj", "./"]
RUN dotnet restore "./samplecoreapp.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "samplecoreapp.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "samplecoreapp.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "samplecoreapp.dll"]
