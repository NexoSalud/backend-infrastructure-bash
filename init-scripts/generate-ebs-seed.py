#!/usr/bin/env python3
"""
Generador de seed data para EBS Contracts a partir de los datos del proyecto original.
Extrae los perfiles, actividades y plantillas del catálogo estático del proyecto
gestionContractos.

Uso: python3 generate-ebs-seed.py > 03-ebs-seed-full.sql
"""

import sys
sys.path.insert(0, '/tmp/gestionContractos')

from services.pdf_generator import ACTIVIDADES_POR_PERFIL, HONORARIOS_POR_PERFIL
from seed_db import PLANTILLAS_OBSERVACIONES

def escape_sql(val):
    """Escape a string for PostgreSQL single-quoted string"""
    if val is None:
        return 'NULL'
    return "'" + val.replace("'", "''") + "'"

def generate_sql():
    lines = []
    lines.append("-- Seed data for EBS Contracts (generated from gestionContractos reference)")
    lines.append("-- Perfiles: Equipos Básicos de Salud (ESE NORTE 3)\n")

    # Clear existing data
    lines.append("-- Clear existing seed data")
    lines.append("DELETE FROM ebs_actividades_perfil;")
    lines.append("DELETE FROM ebs_perfiles;")
    lines.append("DELETE FROM ebs_plantillas_observaciones;")
    lines.append("ALTER SEQUENCE ebs_perfiles_id_seq RESTART WITH 1;")
    lines.append("ALTER SEQUENCE ebs_actividades_perfil_id_seq RESTART WITH 1;")
    lines.append("ALTER SEQUENCE ebs_plantillas_observaciones_id_seq RESTART WITH 1;\n")

    # Only include health-professional profiles (skip university/sindicato which are institutional)
    HEALTH_PROFILES = ["MEDICINA", "ENFERMERIA", "PSICOLOGIA", "SALUD ORAL", 
                        "GESTOR COMUNITARIO", "AUXILIAR VACUNACION", "AUXILIAR ENFERMERIA"]

    # Insert perfiles
    lines.append("-- Insert profiles")
    for perfil_name in HEALTH_PROFILES:
        honorario = HONORARIOS_POR_PERFIL.get(perfil_name.strip().upper(), 0)
        desc = ""
        if perfil_name == "MEDICINA":
            desc = "Profesional médico para atención individual, familiar y comunitaria en el marco de la Resolución 3280 de 2018"
        elif perfil_name == "ENFERMERIA":
            desc = "Profesional de enfermería para implementación del PICP con énfasis materno-perinatal"
        elif perfil_name == "PSICOLOGIA":
            desc = "Profesional de psicología para intervenciones colectivas en salud mental y psicosocial"
        elif perfil_name == "SALUD ORAL":
            desc = "Higienista oral para actividades de promoción y mantenimiento de salud bucal"
        elif perfil_name == "GESTOR COMUNITARIO":
            desc = "Gestor comunitario como enlace entre el equipo de salud y las comunidades"
        elif perfil_name == "AUXILIAR VACUNACION":
            desc = "Auxiliar de enfermería para programa ampliado de inmunizaciones"
        elif perfil_name == "AUXILIAR ENFERMERIA":
            desc = "Auxiliar de enfermería para apoyo a la gestión del EBS"
        
        lines.append(f"INSERT INTO ebs_perfiles (nombre, descripcion, honorario_referencia) VALUES ({escape_sql(perfil_name)}, {escape_sql(desc)}, {honorario});")
    
    lines.append("")

    # Insert actividades for each profile
    perfiles_map = {}
    for i, name in enumerate(HEALTH_PROFILES, 1):
        perfiles_map[name] = i

    lines.append("-- Insert activities for each profile")
    for perfil_name, actividades in ACTIVIDADES_POR_PERFIL.items():
        perfil_upper = perfil_name.strip().upper()
        if perfil_upper not in perfiles_map:
            continue
        
        perfil_id = perfiles_map[perfil_upper]
        for idx, actividad in enumerate(actividades, 1):
            lines.append(f"INSERT INTO ebs_actividades_perfil (perfil_id, descripcion, orden) VALUES ({perfil_id}, {escape_sql(actividad.strip())}, {idx});")

    lines.append("")

    # Insert plantillas
    lines.append("-- Insert observation templates")
    for p in PLANTILLAS_OBSERVACIONES:
        lines.append(f"INSERT INTO ebs_plantillas_observaciones (titulo, contenido) VALUES ({escape_sql(p['titulo'])}, {escape_sql(p['contenido'])});")

    lines.append("")
    lines.append("-- Seed complete!")
    return "\n".join(lines)

if __name__ == "__main__":
    print(generate_sql())
